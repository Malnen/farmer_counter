import 'package:farmer_counter/models/sync_meta.dart';
import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';

import '../common_mocks.dart';

void main() {
  late String dbFilePath;
  late DriveClient driveClient;
  late DriveApi driveApi;
  late FilesResource filesResource;
  late DriveSyncService driveSyncService;
  late Isar isar;

  registerFallbackValue(File());
  registerFallbackValue(UploadOptions());
  registerFallbackValue(DownloadOptions());

  setUp(() async {
    driveClient = MockDriveClient();
    driveApi = MockDriveApi();
    filesResource = MockFilesResource();
    when(
      () => filesResource.list(
        spaces: any(named: 'spaces'),
        q: any(named: 'q'),
        $fields: any(named: r'$fields'),
      ),
    ).thenAnswer((_) async => FileList(files: <File>[]));
    isar = GetIt.instance.get();
    dbFilePath = '${isar.directory}/${isar.name}.isar';

    when(() => driveClient.api).thenReturn(driveApi);
    when(() => driveApi.files).thenReturn(filesResource);
    when(
      () => filesResource.get(
        any(),
        $fields: any(named: r'$fields'),
      ),
    ).thenAnswer(
      (_) async => File()
        ..id = 'id'
        ..md5Checksum = ''
        ..modifiedTime = DateTime.now().toUtc(),
    );
    when(
      () => filesResource.create(
        any(),
        uploadMedia: any(named: 'uploadMedia'),
        $fields: any(named: r'$fields'),
      ),
    ).thenAnswer(
      (_) async => File()
        ..id = 'id'
        ..name = 'testdb.isar',
    );
    when(
      () => filesResource.update(
        any(),
        any(),
        uploadMedia: any(named: 'uploadMedia'),
        uploadOptions: any(named: 'uploadOptions'),
      ),
    ).thenAnswer(
      (_) async => File()
        ..id = 'id'
        ..md5Checksum = 'abc'
        ..modifiedTime = DateTime.now().toUtc(),
    );
    when(
      () => filesResource.get(
        any(),
        downloadOptions: any(named: 'downloadOptions'),
      ),
    ).thenAnswer(
      (_) async => Media(
        Stream<List<int>>.fromIterable(
          <List<int>>[
            <int>[1, 2, 3],
          ],
        ),
        3,
      ),
    );
    driveSyncService = DriveSyncService(
      dbFilePath: dbFilePath,
      baseDir: isar.directory!,
      client: driveClient,
    );
    GetIt.instance.unregister<DriveSyncService>();
    GetIt.instance.registerSingleton<DriveSyncService>(driveSyncService);
    await driveSyncService.init();
  });

  tearDown(() async {
    isar = GetIt.instance.get();
    await isar.close();
  });

  test('init calls syncNow and sets conflict false', () async {
    // given:
    when(() => filesResource.get(any(), $fields: any(named: r'$fields'))).thenAnswer(
      (_) async => File()
        ..id = 'id'
        ..md5Checksum = 'abc'
        ..modifiedTime = DateTime.now().toUtc(),
    );

    // when:
    await driveSyncService.init();

    // then:
    expect(driveSyncService.hasConflict.value, isFalse);
  });

  test('resolveKeepLocal clears conflict', () async {
    // given:
    final File metaFile = File()
      ..id = 'id'
      ..md5Checksum = 'xyz'
      ..modifiedTime = DateTime.now().toUtc();
    when(() => filesResource.get(any(), $fields: any(named: r'$fields'))).thenAnswer((_) async => metaFile);
    when(
      () => filesResource.update(
        any(),
        any(),
        uploadMedia: any(named: 'uploadMedia'),
        uploadOptions: any(named: 'uploadOptions'),
      ),
    ).thenAnswer((_) async => File());

    // when:
    await driveSyncService.resolveKeepLocal();

    // then:
    expect(driveSyncService.hasConflict.value, isFalse);
  });

  test('resolveKeepDrive clears conflict', () async {
    // given:
    final Media media = Media(
      Stream<List<int>>.fromIterable(
        <List<int>>[
          <int>[1, 2, 3],
        ],
      ),
      3,
    );
    when(() => filesResource.get(any(), downloadOptions: any(named: 'downloadOptions'))).thenAnswer((_) async => media);
    when(() => filesResource.get(any(), $fields: any(named: r'$fields'))).thenAnswer(
      (_) async => File()
        ..id = 'id'
        ..md5Checksum = 'abc'
        ..modifiedTime = DateTime.now().toUtc(),
    );

    // when:
    await driveSyncService.resolveKeepDrive();

    // then:
    expect(driveSyncService.hasConflict.value, isFalse);
  });

  test('conflict detection sets hasConflict true', () async {
    // given:
    when(() => filesResource.get(any(), $fields: any(named: r'$fields'))).thenAnswer(
      (_) async => File()
        ..id = 'id'
        ..md5Checksum = 'different'
        ..modifiedTime = DateTime.now().toUtc(),
    );
    final Isar isar = GetIt.I<Isar>();
    await isar.writeTxn(() async {
      final SyncMeta meta = SyncMeta(id: 1, lastModified: DateTime.now().toUtc());
      await isar.syncMetas.put(meta);
    });

    // when:
    await driveSyncService.syncNow();

    // then:
    expect(driveSyncService.hasConflict.value, isTrue);
  });
}
