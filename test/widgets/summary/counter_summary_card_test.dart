import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/enums/date_range_preset.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:farmer_counter/extensions/summary_metric_extension.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_summary.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
import 'package:farmer_counter/widgets/summary/counter_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';

import '../../test_material_app.dart';

void main() {
  late Isar isar;
  late CounterItem counter;
  late Widget app;

  setUp(() async {
    isar = GetIt.instance.get<Isar>();
    counter = CounterItem.create(name: 'SummaryTest');
    await isar.writeTxn(() async => isar.counterItems.put(counter));
    app = TestMaterialApp(
      home: Scaffold(
        body: BlocProvider<SettingsCubit>(
          create: (BuildContext context) => SettingsCubit(),
          child: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
            create: (_) => ValueNotifier<CounterItem>(counter),
            child: SingleChildScrollView(
              child: CounterSummaryCard(
                initialSelection: DateRangeSelection.fromPreset(DateRangePreset.today),
              ),
            ),
          ),
        ),
      ),
    );
  });

  testWidgets('should render summary card with counter name', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder card = find.byType(CounterSummaryCard);
      expect(card, findsOneWidget);
      final Finder text = find.text('SummaryTest');
      expect(text, findsOneWidget);
    });
  });

  testWidgets('should display zero summary when no history', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder count = find.text('0');
      expect(count, findsNWidgets(8));
    });
  });

  testWidgets('should calculate summary with changes', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await isar.writeTxn(() async {
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: counter.guid, delta: 5, newValue: 5),
        );
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: counter.guid, delta: -2, newValue: 3),
        );
      });

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder card = find.byType(CounterSummaryCard);
      final CounterSummaryCardState state = tester.state(card) as CounterSummaryCardState;
      final CounterSummary summary = await state.getCounterSummary(
        counter: counter,
        start: DateTime.now().subtract(const Duration(days: 1)),
        end: DateTime.now().add(const Duration(days: 1)),
      );
      expect(summary.startValue, 0);
      expect(summary.endValue, 3);
      expect(summary.addedCount, 5);
      expect(summary.removedCount, 2);
    });
  });

  testWidgets('should update selection when preset tapped', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      final Finder sixMonths = find.text('counter_summary_card.six_months'.tr());
      await tester.ensureVisible(sixMonths);
      await tester.tap(sixMonths);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder card = find.byType(CounterSummaryCard);
      final CounterSummaryCardState state = tester.state(card) as CounterSummaryCardState;
      expect(state.selectedDateRange.preset, DateRangePreset.sixMonths);
    });
  });

  testWidgets('should handle empty custom date range gracefully', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder card = find.byType(CounterSummaryCard);
      final CounterSummaryCardState state = tester.state(card) as CounterSummaryCardState;

      final CounterSummary summary = await state.getCounterSummary(
        counter: counter,
        start: DateTime.now(),
        end: DateTime.now(),
      );

      // then:
      expect(summary.startValue, counter.count);
      expect(summary.endValue, counter.count);
    });
  });

  testWidgets('should respect settings metrics visibility', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder card = find.byType(CounterSummaryCard);
      final CounterSummaryCardState state = tester.state(card) as CounterSummaryCardState;
      final Iterable<SummaryMetric> metrics = SummaryMetric.values.where(state.settingsCubit.isSummaryMetricEnabled);

      // then:
      for (final SummaryMetric metric in metrics) {
        expect(find.text(metric.label), findsWidgets);
      }
    });
  });
}
