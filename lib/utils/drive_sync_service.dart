import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/models/remote_file.dart';
import 'package:farmer_counter/models/sync_meta.dart';
import 'package:farmer_counter/models/sync_state.dart';
import 'package:farmer_counter/utils/drive_client.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:isar_community/isar.dart';
import 'package:path/path.dart' as path;

class DriveSyncService {
  static const String _stateFileName = 'sync_state.json';
  static const String _localSnapshotName = 'db_snapshot.isar';

  final String dbFilePath;
  final String baseDir;
  final DriveClient client;
  final ValueNotifier<bool> hasConflict;
  final ValueNotifier<Isar> isarNotifier;

  final List<StreamSubscription<Object?>> _isarSubscriptions;

  SyncState _state;
  StreamSubscription<List<ConnectivityResult>>? _connectionSubscription;
  bool _syncing;

  DriveSyncService({
    required this.dbFilePath,
    required this.baseDir,
    DriveClient? client,
  })  : client = client ?? DriveClient(),
        hasConflict = ValueNotifier<bool>(false),
        isarNotifier = ValueNotifier<Isar>(GetIt.instance.get()),
        _state = SyncState.empty(),
        _isarSubscriptions = <StreamSubscription<Object?>>[],
        _syncing = false;

  Future<void> init() async {
    await _loadState();
    _initCollectionSubscriptions();
    _connectionSubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> response) async {
        if (response.every(
              (ConnectivityResult element) => element != ConnectivityResult.none,
            ) &&
            _state.needsUpload) {
          _state = _state.copyWith(needsUpload: false);
          await _saveState();
          await syncNow();
        }
      },
    );

    await syncNow();
  }

  Future<void> dispose() async {
    for (final StreamSubscription<Object?> sub in _isarSubscriptions) {
      await sub.cancel();
    }

    await _connectionSubscription?.cancel();
  }

  Future<void> syncNow() async {
    if (_syncing) {
      return;
    }

    _syncing = true;
    try {
      final drive.DriveApi? driveApi = client.api;
      if (driveApi == null) {
        return;
      }

      Isar isar = GetIt.instance.get();
      final SyncMeta? metaRow = await isar.syncMetas.get(1);
      final DateTime localModified = metaRow?.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);

      final RemoteFile remote = await _ensureRemoteFile(driveApi);
      final drive.File meta = await driveApi.files.get(
        remote.id,
        $fields: 'id,md5Checksum,modifiedTime',
      ) as drive.File;

      final String remoteMd5 = meta.md5Checksum ?? '';
      final DateTime? remoteModified = meta.modifiedTime?.toUtc();

      final bool localChanged = _state.lastLocalModified == null || localModified.isAfter(_state.lastLocalModified!);
      final bool remoteChanged = _state.lastRemoteMd5 != remoteMd5;

      if (localChanged && remoteChanged) {
        hasConflict.value = true;
        _state = _state.copyWith(pendingConflict: true);
        await _saveState();
        return;
      }

      if (localChanged && !remoteChanged) {
        final File localSnap = await _snapshotDb();
        await _uploadReplace(driveApi, remote.id, localSnap);

        final drive.File newMeta = await driveApi.files.get(
          remote.id,
          $fields: 'md5Checksum,modifiedTime',
        ) as drive.File;

        _state = _state.copyWith(
          lastLocalModified: localModified,
          lastRemoteMd5: newMeta.md5Checksum ?? '',
          lastRemoteModified: newMeta.modifiedTime?.toUtc(),
        );
      }

      if (!localChanged && remoteChanged) {
        await _downloadAndRestore(driveApi, remote.id);
        isar = GetIt.instance.get();
        final SyncMeta? afterRestore = await isar.syncMetas.get(1);

        _state = _state.copyWith(
          lastLocalModified: afterRestore?.lastModified ?? DateTime.now().toUtc(),
          lastRemoteMd5: remoteMd5,
          lastRemoteModified: remoteModified,
        );
      }

      hasConflict.value = false;
      _state = _state.copyWith(
        pendingConflict: false,
        lastSyncedAt: DateTime.now().toUtc(),
      );
      await _saveState();
    } finally {
      _syncing = false;
    }
  }

  Future<void> resolveKeepLocal() async {
    final drive.DriveApi? driveApi = client.api;
    if (driveApi == null) {
      return;
    }

    final File localSnap = await _snapshotDb();
    await _uploadReplace(driveApi, _state.remoteFileId, localSnap);

    final drive.File newMeta = await driveApi.files.get(
      _state.remoteFileId,
      $fields: 'md5Checksum,modifiedTime',
    ) as drive.File;

    final Isar isar = GetIt.instance.get();
    final SyncMeta? metaRow = await isar.syncMetas.get(1);

    hasConflict.value = false;
    _state = _state.copyWith(
      lastLocalModified: metaRow?.lastModified ?? DateTime.now().toUtc(),
      lastRemoteMd5: newMeta.md5Checksum ?? '',
      lastRemoteModified: newMeta.modifiedTime?.toUtc(),
      pendingConflict: false,
      lastSyncedAt: DateTime.now().toUtc(),
    );
    await _saveState();
  }

  Future<void> resolveKeepDrive() async {
    final drive.DriveApi? driveApi = client.api;
    if (driveApi == null) {
      return;
    }

    await _downloadAndRestore(driveApi, _state.remoteFileId);
    final drive.File meta = await driveApi.files.get(
      _state.remoteFileId,
      $fields: 'md5Checksum,modifiedTime',
    ) as drive.File;

    final Isar isar = GetIt.instance.get();
    final SyncMeta? afterRestore = await isar.syncMetas.get(1);

    hasConflict.value = false;
    _state = _state.copyWith(
      lastLocalModified: afterRestore?.lastModified ?? DateTime.now().toUtc(),
      lastRemoteMd5: meta.md5Checksum ?? '',
      lastRemoteModified: meta.modifiedTime?.toUtc(),
      pendingConflict: false,
      lastSyncedAt: DateTime.now().toUtc(),
    );
    await _saveState();
  }

  Future<void> resolveKeepBoth() async {
    final drive.DriveApi? driveApi = client.api;
    if (driveApi == null) {
      return;
    }

    final File localSnap = await _snapshotDb();
    final String ts = DateTime.now().toIso8601String().replaceAll(':', '-');
    final String altName = '${path.basename(dbFilePath).replaceAll('.isar', '')}-$ts.isar';

    await driveApi.files.create(
      drive.File()
        ..name = altName
        ..parents = <String>['root'],
      uploadMedia: drive.Media(
        localSnap.openRead(),
        await localSnap.length(),
      ),
    );

    await resolveKeepLocal();
  }

  Future<void> _onLocalChange() async {
    final List<ConnectivityResult> response = await Connectivity().checkConnectivity();
    if (response.any((ConnectivityResult element) => element == ConnectivityResult.none)) {
      _state = _state.copyWith(needsUpload: true);
      await _saveState();
      return;
    }

    await syncNow();
  }

  Future<File> _snapshotDb() async {
    final File file = File(path.join(baseDir, _localSnapshotName));
    if (await file.exists()) {
      await file.delete();
    }

    final Isar isar = GetIt.instance.get();
    await isar.copyToFile(file.path);

    return file;
  }

  Future<RemoteFile> _ensureRemoteFile(drive.DriveApi api) async {
    final String fileName = path.basename(dbFilePath);
    if (_state.remoteFileId.isNotEmpty) {
      try {
        final drive.File f = await api.files.get(
          _state.remoteFileId,
          $fields: 'id,name,trashed',
        ) as drive.File;
        if (f.trashed == true) {
          _state = _state.copyWith(remoteFileId: '');
        } else {
          return RemoteFile(_state.remoteFileId, fileName);
        }
      } catch (_) {
        _state = _state.copyWith(remoteFileId: '');
      }
    }

    final String query = "name = '$fileName' and trashed = false and 'root' in parents";
    final drive.FileList result = await api.files.list(
      spaces: 'drive',
      q: query,
      $fields: 'files(id,name)',
    );

    if (result.files != null && result.files!.isNotEmpty) {
      _state = _state.copyWith(remoteFileId: result.files!.first.id!);
      await _saveState();
      return RemoteFile(_state.remoteFileId, fileName);
    }

    final File localSnap = await _snapshotDb();
    final drive.File created = await api.files.create(
      drive.File()
        ..name = fileName
        ..parents = <String>['root'],
      uploadMedia: drive.Media(localSnap.openRead(), await localSnap.length()),
      $fields: 'id,name',
    );

    _state = _state.copyWith(remoteFileId: created.id!);
    await _saveState();

    return RemoteFile(created.id!, created.name!);
  }

  Future<void> _uploadReplace(
    drive.DriveApi api,
    String fileId,
    File snap,
  ) async {
    final drive.Media media = drive.Media(snap.openRead(), await snap.length());
    await api.files.update(
      drive.File(),
      fileId,
      uploadMedia: media,
      uploadOptions: drive.ResumableUploadOptions(),
    );
  }

  Future<void> _downloadAndRestore(
    drive.DriveApi api,
    String fileId,
  ) async {
    final File tmp = File(path.join(baseDir, 'remote_restore.isar'));
    final drive.Media media = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;
    final IOSink sink = tmp.openWrite();
    await media.stream.pipe(sink);
    await sink.close();

    final Isar isar = GetIt.instance.get();
    await isar.close();

    final File target = File(dbFilePath);
    if (await target.exists()) {
      await target.delete();
    }

    await tmp.rename(target.path);
    final Isar newIsar = await Isar.open(
      <CollectionSchema<Object?>>[
        CounterItemSchema,
        CounterChangeItemSchema,
        CounterItemNoteSchema,
        SyncMetaSchema,
      ],
      directory: path.dirname(dbFilePath),
      name: isar.name,
    );

    if (GetIt.instance.isRegistered<Isar>()) {
      GetIt.instance.unregister<Isar>();
    }

    GetIt.instance.registerSingleton<Isar>(newIsar);
    _initCollectionSubscriptions();
    isarNotifier.value = newIsar;
  }

  Future<void> _loadState() async {
    final File file = File(path.join(baseDir, _stateFileName));
    if (await file.exists()) {
      final Map<String, Object?> json = jsonDecode(await file.readAsString()) as Map<String, Object?>;
      _state = SyncState.fromJson(json);
    }
  }

  Future<void> _saveState() async {
    final File file = File(path.join(baseDir, _stateFileName));
    await file.writeAsString(jsonEncode(_state.toJson()));
  }

  void _initCollectionSubscriptions() {
    for (StreamSubscription<Object?> subscription in _isarSubscriptions) {
      subscription.cancel();
    }

    final Isar isar = GetIt.instance.get();
    final List<IsarCollection<Object>> collections = <IsarCollection<Object>>[
      isar.collection<CounterItem>(),
      isar.collection<CounterChangeItem>(),
      isar.collection<CounterItemNote>(),
    ];

    for (final IsarCollection<Object> col in collections) {
      _isarSubscriptions.add(
        col.watchLazy().listen((_) async {
          await isar.writeTxn(() async {
            SyncMeta meta = await isar.syncMetas.get(1) ?? SyncMeta(id: 1, lastModified: DateTime.now().toUtc());
            meta = meta.copyWith(lastModified: DateTime.now().toUtc());
            await isar.syncMetas.put(meta);
          });

          await Future<void>.delayed(const Duration(seconds: 5));
          await _onLocalChange();
        }),
      );
    }
  }
}
