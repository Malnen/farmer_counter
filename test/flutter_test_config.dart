import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  await EasyLocalization.ensureInitialized();

  late Directory temporary;
  late Isar isar;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    temporary = await Directory.systemTemp.createTemp('farmer_counter_test_');
    isar = await Isar.open(
      <CollectionSchema<Object?>>[
        CounterItemSchema,
        CounterChangeItemSchema,
      ],
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
