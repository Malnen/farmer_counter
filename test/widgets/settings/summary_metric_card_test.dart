import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:farmer_counter/widgets/pages/summary_metrics_page.dart';
import 'package:farmer_counter/widgets/settings/summary_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late SettingsCubit cubit;
  late Widget app;

  setUp(() {
    cubit = SettingsCubit();
    app = TestMaterialApp(
      home: Scaffold(
        body: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const SummaryMetricsCard(),
        ),
      ),
    );
  });

  testWidgets('renders with title and subtitle', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder title = find.text('settings.summary_metrics.title'.tr());
      await tester.waitForFinder(title);
      expect(title, findsOneWidget);
      final Finder subtitle = find.text(
        'settings.summary_metrics.subtitle'.tr(
          namedArgs: <String, String>{'count': '${SummaryMetric.values.length}'},
        ),
      );
      expect(subtitle, findsOneWidget);
    });
  });

  testWidgets('subtitle updates when metrics toggled', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      cubit.setSummaryMetric(SummaryMetric.added, false);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder subtitle = find.text(
        'settings.summary_metrics.subtitle'.tr(
          namedArgs: <String, String>{'count': '${SummaryMetric.values.length - 1}'},
        ),
      );
      await tester.waitForFinder(subtitle);
      expect(subtitle, findsOneWidget);
    });
  });

  testWidgets('navigates to SummaryMetricsPage on tap', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      final Finder tile = find.byType(ListTile);
      await tester.waitForFinder(tile);
      await tester.tap(tile);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder page = find.byType(SummaryMetricsPage);
      await tester.waitForFinder(page);
      expect(page, findsOneWidget);
    });
  });
}
