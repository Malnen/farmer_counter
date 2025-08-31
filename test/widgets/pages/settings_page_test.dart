import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:farmer_counter/widgets/google_drive/google_drive_connected_card.dart';
import 'package:farmer_counter/widgets/google_drive/google_drive_disconnected_card.dart';
import 'package:farmer_counter/widgets/pages/settings_page.dart';
import 'package:farmer_counter/widgets/settings/plus_minus_order_card.dart';
import 'package:farmer_counter/widgets/settings/summary_metric_card.dart';
import 'package:farmer_counter/widgets/settings/tab_bar_size_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../test_material_app.dart';

void main() {
  late DriveSyncService syncService;
  late DriveClient client;
  late Widget app;

  setUp(() {
    syncService = GetIt.instance.get();
    client = syncService.client;
    app = TestMaterialApp(
      home: Scaffold(
        body: BlocProvider<SettingsCubit>(
          create: (BuildContext context) => SettingsCubit(),
          child: SingleChildScrollView(
            child: SettingsPage(syncService: syncService),
          ),
        ),
      ),
    );
  });

  testWidgets('renders always present widgets', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder summaryMetrics = find.byType(SummaryMetricsCard);
      expect(summaryMetrics, findsOneWidget);
      final Finder plusMinus = find.byType(PlusMinusOrderCard);
      expect(plusMinus, findsOneWidget);
      final Finder tabBarSize = find.byType(TabBarSizeCard);
      expect(tabBarSize, findsOneWidget);
    });
  });

  testWidgets('shows disconnected card when authState is disconnected', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      client.authState.value = DriveAuthState.disconnected;

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder disconnected = find.byType(GoogleDriveDisConnectedCard);
      expect(disconnected, findsOneWidget);
      final Finder connected = find.byType(GoogleDriveConnectedCard);
      expect(connected, findsNothing);
    });
  });

  testWidgets('shows connected card when authState is connected', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      client.authState.value = DriveAuthState.connected;

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder connected = find.byType(GoogleDriveConnectedCard);
      expect(connected, findsOneWidget);
      final Finder disconnected = find.byType(GoogleDriveDisConnectedCard);
      expect(disconnected, findsNothing);
    });
  });
}
