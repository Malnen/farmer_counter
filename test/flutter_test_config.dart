import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/src/enums.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  EasyLocalization.logger.enableLevels = <LevelMessages>[LevelMessages.error, LevelMessages.warning];
  await EasyLocalization.ensureInitialized();

  late Directory temporary;
  late Isar isar;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    temporary = await Directory.systemTemp.createTemp('farmer_counter_test_');
    isar = await Isar.open(
      <CollectionSchema<Object?>>[CounterItemSchema, CounterChangeItemSchema, CounterItemNoteSchema],
      directory: temporary.path,
    );
    GetIt.instance.registerSingleton<Isar>(isar);
    await pumpEventQueue();
  });

  tearDown(() async {
    await isar.close();
    try {
      await temporary.delete(recursive: true);
    } catch (_) {}

    GetIt.instance.unregister<Isar>();
  });

  await testMain();
}
