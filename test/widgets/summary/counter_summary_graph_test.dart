import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/enums/counter_chart_type.dart';
import 'package:farmer_counter/enums/date_range_preset.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
import 'package:farmer_counter/widgets/summary/counter_summary_graph.dart';
import 'package:farmer_counter/widgets/summary/graph/counter_chart_type_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late Isar isar;
  late CounterItem item;
  late Widget app;
  late CounterCubit counterCubit;
  late ValueNotifier<CounterItem> itemNotifier;

  setUp(() async {
    counterCubit = CounterCubit();
    isar = GetIt.instance.get<Isar>();
    item = (await counterCubit.addItem('GraphTest'))!;
    itemNotifier = ValueNotifier<CounterItem>(item);
    app = TestMaterialApp(
      home: Scaffold(
        body: BlocProvider<CounterCubit>.value(
          value: counterCubit,
          child: ChangeNotifierProvider<ValueNotifier<CounterItem>>.value(
            value: itemNotifier,
            child: CounterSummaryGraph(
              selection: DateRangeSelection.fromPreset(
                DateRangePreset.today,
              ),
            ),
          ),
        ),
      ),
    );
  });

  testWidgets('should render empty state when no data', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder graph = find.byType(CounterSummaryGraph);
      await tester.waitForFinder(graph);
      expect(graph, findsOneWidget);
      final Finder noData = find.text('No data');
      await tester.waitForFinder(noData);
      expect(noData, findsOneWidget);
    });
  });

  testWidgets('should render bar chart when data exists', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await isar.writeTxn(() async {
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: 5, newValue: 5),
        );
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: -3, newValue: 2),
        );
      });

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder graph = find.byType(CounterSummaryGraph);
      await tester.waitForFinder(graph);
      expect(graph, findsOneWidget);
      final Finder chart = find.byType(BarChart);
      await tester.waitForFinder(chart);
      expect(chart, findsNWidgets(2));
    });
  });
  testWidgets('should show loading indicator initially', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();

      // then:
      final Finder loader = find.byType(CircularProgressIndicator);
      expect(loader, findsOneWidget);
      await pumpEventQueue();
    });
  });

  testWidgets('should handle positive and negative values correctly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await isar.writeTxn(() async {
        await isar.counterChangeItems.put(
          CounterChangeItem.create(
            counterGuid: item.guid,
            delta: 10,
            newValue: 10,
          ),
        );
        await isar.counterChangeItems.put(
          CounterChangeItem.create(
            counterGuid: item.guid,
            delta: -7,
            newValue: 3,
          ),
        );
      });

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder charts = find.byType(BarChart);
      await tester.waitForFinder(charts);

      expect(charts, findsNWidgets(2));

      final BarChart axisChart = tester.widgetList<BarChart>(charts).first;
      final BarChart dataChart = tester.widgetList<BarChart>(charts).last;

      expect(axisChart.data.minY, lessThanOrEqualTo(-7));
      expect(dataChart.data.maxY, greaterThanOrEqualTo(10));
    });
  });

  testWidgets('should reload graph when date range changes', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await isar.writeTxn(() async {
        await isar.counterChangeItems.put(
          CounterChangeItem.create(
            counterGuid: item.guid,
            delta: 1,
            newValue: 1,
          ),
        );
      });

      // when:
      final Widget updatedApp = TestMaterialApp(
        home: Scaffold(
          body: BlocProvider<CounterCubit>.value(
            value: counterCubit,
            child: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
              create: (_) => ValueNotifier<CounterItem>(item),
              child: CounterSummaryGraph(
                selection: DateRangeSelection.fromPreset(
                  DateRangePreset.thisWeek,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(updatedApp);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder graph = find.byType(CounterSummaryGraph);
      await tester.waitForFinder(graph);
      expect(graph, findsOneWidget);
      final Finder charts = find.byType(BarChart);
      await tester.waitForFinder(charts);
      expect(charts, findsNWidgets(2));
    });
  });

  testWidgets('should render graph type selector', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder selector = find.byType(CounterChartTypeSelector);
      await tester.waitForFinder(selector);
      expect(selector, findsOneWidget);
    });
  });

  testWidgets('should switch from bar chart to line chart', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await isar.writeTxn(() async {
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: 5, newValue: 5),
        );
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: -3, newValue: 2),
        );
      });

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder barCharts = find.byType(BarChart);
      await tester.waitForFinder(barCharts);
      expect(barCharts, findsNWidgets(2));

      // when:
      itemNotifier.value = item.copyWith(lastSelectedChartType: CounterChartType.line);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder lineChart = find.byType(LineChart);
      await tester.waitForFinder(lineChart);
      expect(lineChart, findsOneWidget);
    });
  });
}
