import 'dart:io';

import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/app_main.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _registerCounterIsar();
  runApp(const AppMain());
}

Future<void> _registerCounterIsar() async {
  final Directory directory = await _getIsarDirectory();
  final Isar isar = await Isar.open(
    <CollectionSchema<CounterItem>>[CounterItemSchema],
    directory: directory.path,
  );

  GetIt.instance.registerSingleton<Isar>(isar);
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
