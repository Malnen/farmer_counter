import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_host.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../test_material_app.dart';
import '../when_extension.dart';

void main() {
  late DriveSyncService syncService;
  late DriveClient client;
  late Widget app;

  setUp(() {
    syncService = GetIt.instance.get();
    client = syncService.client;
    app = TestMaterialApp(
      home: Scaffold(
        body: DriveSyncHost(
          child: const Text('child'),
        ),
      ),
    );

    when(client.loadState).thenDoNothing();
    when(syncService.init).thenDoNothing();
    when(syncService.dispose).thenDoNothing();
    when(syncService.resolveKeepLocal).thenDoNothing();
    when(syncService.resolveKeepDrive).thenDoNothing();
    when(syncService.resolveKeepBoth).thenDoNothing();
  });

  testWidgets('renders child and calls init + loadState', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder child = find.text('child');
      expect(child, findsOneWidget);
      verify(client.loadState).called(1);
      verify(syncService.init).called(1);
    });
  });

  testWidgets('shows conflict dialog -> choose local calls resolveKeepLocal', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // when:
      syncService.hasConflict.value = true;
      await tester.pumpAndSettle();
      final Finder localButton = find.text('drive_sync.conflict.keep_local'.tr());
      await tester.tap(localButton);
      await tester.pumpAndSettle();

      // then:
      verify(syncService.resolveKeepLocal).called(1);
    });
  });

  testWidgets('shows conflict dialog -> choose drive calls resolveKeepDrive', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // when:
      syncService.hasConflict.value = true;
      await tester.pumpAndSettle();
      final Finder driveButton = find.text('drive_sync.conflict.keep_drive'.tr());
      await tester.tap(driveButton);
      await tester.pumpAndSettle();

      // then:
      verify(syncService.resolveKeepDrive).called(1);
    });
  });

  testWidgets('shows conflict dialog -> choose both calls resolveKeepBoth', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // when:
      syncService.hasConflict.value = true;
      await tester.pumpAndSettle();
      final Finder bothButton = find.text('drive_sync.conflict.keep_both'.tr());
      await tester.tap(bothButton);
      await tester.pumpAndSettle();

      // then:
      verify(syncService.resolveKeepBoth).called(1);
    });
  });

  testWidgets('shows conflict dialog -> dismiss clears conflict flag', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // when:
      syncService.hasConflict.value = true;
      await tester.pumpAndSettle();
      final Finder dialog = find.byType(AlertDialog);
      Navigator.of(tester.element(dialog)).pop();
      await tester.pumpAndSettle();

      // then:
      expect(syncService.hasConflict.value, isFalse);
    });
  });
}
