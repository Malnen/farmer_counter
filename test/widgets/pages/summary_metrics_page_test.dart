import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:farmer_counter/extensions/summary_metric_extension.dart';
import 'package:farmer_counter/widgets/pages/summary_metrics_page.dart';
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
      home: BlocProvider<SettingsCubit>.value(
        value: cubit,
        child: const SummaryMetricsPage(),
      ),
    );
  });

  testWidgets('renders with app bar title', (WidgetTester tester) async {
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
    });
  });

  testWidgets('renders a switch for each SummaryMetric', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      for (final SummaryMetric metric in SummaryMetric.values) {
        Finder label = find.text(metric.label);
        if (label.evaluate().isEmpty) {
          await tester.scrollUntilVisible(
            find.text(metric.label),
            200.0,
            scrollable: find.byType(Scrollable),
          );
        }
        label = find.text(metric.label);
        expect(label, findsOneWidget);
        final Finder description = find.text(metric.description);
        expect(description, findsOneWidget);
        final Finder icon = find.byIcon(metric.icon);
        expect(icon, findsOneWidget);
      }
    });
  });

  testWidgets('toggling a metric updates cubit state', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final SummaryMetric metric = SummaryMetric.added;
      final Finder tile = find.text(metric.label);
      await tester.waitForFinder(tile);
      bool enabled = cubit.isSummaryMetricEnabled(metric);
      expect(enabled, true);

      // when:
      await tester.tap(tile);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      enabled = cubit.isSummaryMetricEnabled(metric);
      expect(enabled, false);
    });
  });
}
