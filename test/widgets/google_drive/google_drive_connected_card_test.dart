import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:farmer_counter/widgets/google_drive/google_drive_connected_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late DriveSyncService syncService;
  late Widget app;

  setUp(() {
    syncService = GetIt.instance.get();
    app = TestMaterialApp(
      home: Scaffold(
        body: GoogleDriveConnectedCard(syncService: syncService),
      ),
    );
  });

  testWidgets('renders with connected icon and texts', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder byIcon = find.byIcon(Icons.cloud_done);
      await tester.waitForFinder(byIcon);
      expect(byIcon, findsOneWidget);
      final Finder title = find.text('settings.drive.connected_title'.tr());
      expect(title, findsOneWidget);
      final Finder syncNow = find.text('settings.drive.sync_now'.tr());
      expect(syncNow, findsOneWidget);
      final Finder disconnect = find.text('settings.drive.disconnect'.tr());
      expect(disconnect, findsOneWidget);
    });
  });

  testWidgets('triggers syncNow and shows snackbar', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      final Finder syncNow = find.text('settings.drive.sync_now'.tr());
      await tester.waitForFinder(syncNow);
      await tester.tap(syncNow);
      await tester.pumpAndSettle();

      // then:
      verify(syncService.syncNow).called(1);
      final Finder syncTriggered = find.text('settings.drive.sync_triggered'.tr());
      expect(syncTriggered, findsOneWidget);
    });
  });

  testWidgets('shows confirm dialog and disconnects on confirm', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      final Finder disconnect = find.text('settings.drive.disconnect'.tr());
      await tester.waitForFinder(disconnect);
      await tester.tap(disconnect);

      // then:
      final Finder dialog = find.byType(AlertDialog);
      await tester.waitForFinder(dialog);
      expect(dialog, findsOneWidget);

      // when:
      final Finder confirm = find.descendant(
        of: dialog,
        matching: find.text('settings.drive.disconnect_confirm.confirm'.tr()),
      );
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      // then:
      final DriveClient client = syncService.client;
      verify(client.disconnect).called(1);
      final Finder disconnected = find.text('settings.drive.disconnected_snackbar'.tr());
      expect(disconnected, findsOneWidget);
    });
  });
}
