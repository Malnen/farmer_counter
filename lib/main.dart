import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

// ignore: implementation_imports
import 'package:easy_logger/src/enums.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/models/sync_meta.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:farmer_counter/widgets/app_main.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.logger.enableLevels = <LevelMessages>[LevelMessages.error, LevelMessages.warning];
  await EasyLocalization.ensureInitialized();
  final Isar isar = await _registerCounterIsar();
  final String dbFilePath = '${isar.directory}/${isar.name}.isar';
  _registerDriveSyncService(isar, dbFilePath);
  runApp(AppMain());
}

Future<Isar> _registerCounterIsar() async {
  final Directory directory = await _getIsarDirectory();
  final Isar isar = await Isar.open(
    name: 'farmer_counter',
    <CollectionSchema<Object?>>[
      CounterItemSchema,
      CounterChangeItemSchema,
      CounterItemNoteSchema,
      SyncMetaSchema,
    ],
    directory: directory.path,
  );

  GetIt.instance.registerSingleton<Isar>(isar);
  return isar;
}

DriveSyncService _registerDriveSyncService(Isar isar, String dbFilePath) {
  final DriveSyncService syncService = DriveSyncService(
    dbFilePath: dbFilePath,
    baseDir: isar.directory!,
  );
  GetIt.instance.registerSingleton(syncService);

  return syncService;
}

Future<Directory> _getIsarDirectory() async {
  final Directory? documents = (await getExternalStorageDirectories(type: StorageDirectory.documents))?.first;
  if (documents != null) {
    final Directory databaseDirectory = Directory('${documents.path}/FarmerCounter');
    if (!await databaseDirectory.exists()) {
      await databaseDirectory.create(recursive: true);
    }

    return databaseDirectory;
  }

  return getApplicationDocumentsDirectory();
}
