import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/src/enums.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_mocks.dart';
import 'in_memory_storage.dart';
import 'when_extension.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  EasyLocalization.logger.enableLevels = <LevelMessages>[LevelMessages.error, LevelMessages.warning];
  await EasyLocalization.ensureInitialized();

  late Directory temporary;
  late Isar isar;

  setUp(() async {
    HydratedBloc.storage = InMemoryStorage();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    temporary = await Directory.systemTemp.createTemp('farmer_counter_test_');
    isar = await Isar.open(
      <CollectionSchema<Object?>>[CounterItemSchema, CounterChangeItemSchema, CounterItemNoteSchema],
      directory: temporary.path,
    );
    GetIt.instance.registerSingleton<Isar>(isar);
    final MockDriveSyncService syncService = MockDriveSyncService();
    when(() => syncService.isarNotifier).thenReturn(ValueNotifier<Isar>(isar));
    when(() => syncService.hasConflict).thenReturn(ValueNotifier<bool>(false));
    final MockDriveClient client = MockDriveClient();
    when(client.loadState).thenDoNothing();
    when(client.disconnect).thenDoNothing();
    when(() => client.authState).thenReturn(ValueNotifier<DriveAuthState>(DriveAuthState.disconnected));
    when(() => syncService.client).thenReturn(client);
    when(syncService.init).thenDoNothing();
    when(syncService.dispose).thenDoNothing();
    when(syncService.syncNow).thenDoNothing();
    GetIt.instance.registerSingleton<DriveSyncService>(syncService);
    await pumpEventQueue();
  });

  tearDown(() async {
    await isar.close();
    try {
      await temporary.delete(recursive: true);
    } catch (_) {}

    GetIt.instance.unregister<Isar>();
    GetIt.instance.unregister<DriveSyncService>();
  });

  await testMain();
}
