import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:farmer_counter/widgets/google_drive/google_drive_disconnected_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_material_app.dart';
import '../../when_extension.dart';

void main() {
  late DriveSyncService syncService;
  late DriveClient client;
  late ValueNotifier<bool> loading;
  late Widget app;

  setUp(() {
    syncService = GetIt.instance.get();
    client = syncService.client;
    loading = ValueNotifier<bool>(false);
    app = TestMaterialApp(
      home: Scaffold(
        body: GoogleDriveDisConnectedCard(
          syncService: syncService,
          loading: loading,
        ),
      ),
    );
  });

  testWidgets('renders with icon, title, and connect button', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder icon = find.byIcon(Icons.cloud);
      expect(icon, findsOneWidget);
      final Finder title = find.text('settings.drive.not_connected_title'.tr());
      expect(title, findsOneWidget);
      final Finder connect = find.text('settings.drive.connect'.tr());
      expect(connect, findsOneWidget);
    });
  });

  testWidgets('tapping connect succeeds -> shows snackbar and calls syncNow', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      when(client.connect).thenAnswer((_) async => true);
      when(syncService.syncNow).thenDoNothing();

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      final Finder connect = find.text('settings.drive.connect'.tr());
      await tester.tap(connect);
      await tester.pumpAndSettle();

      // then:
      verify(client.connect).called(1);
      final Finder snackbar = find.text('settings.drive.connected_snackbar'.tr());
      expect(snackbar, findsOneWidget);
      verify(syncService.syncNow).called(1);
    });
  });

  testWidgets('tapping connect fails -> shows snackbar and no syncNow', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      when(client.connect).thenAnswer((_) async => false);
      when(syncService.syncNow).thenDoNothing();

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      final Finder connect = find.text('settings.drive.connect'.tr());
      await tester.tap(connect);
      await tester.pumpAndSettle();

      // then:
      verify(client.connect).called(1);
      final Finder snackbar = find.text('settings.drive.failed_snackbar'.tr());
      expect(snackbar, findsOneWidget);
      verifyNever(syncService.syncNow);
    });
  });
}
