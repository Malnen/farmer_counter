import 'package:farmer_counter/enums/date_range_preset.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
import 'package:farmer_counter/widgets/summary/counter_summary_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';

import '../../test_material_app.dart';

void main() {
  late Isar isar;
  late CounterItem item;
  late Widget app;

  setUp(() async {
    isar = GetIt.instance.get<Isar>();
    item = CounterItem.create(name: 'GraphTest');
    await isar.writeTxn(() async => isar.counterItems.put(item));
    app = TestMaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
          create: (_) => ValueNotifier<CounterItem>(item),
          child: CounterSummaryGraph(
            selection: DateRangeSelection.fromPreset(
              DateRangePreset.today,
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
      await tester.pumpAndSettle();

      // then:
      final Finder graph = find.byType(CounterSummaryGraph);
      expect(graph, findsOneWidget);
      final Finder noData = find.text('No data');
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
      app = TestMaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
            create: (_) => ValueNotifier<CounterItem>(item),
            child: CounterSummaryGraph(
              selection: DateRangeSelection.fromPreset(
                DateRangePreset.today,
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder graph = find.byType(CounterSummaryGraph);
      expect(graph, findsOneWidget);
      final Finder chart = find.byType(BarChart);
      expect(chart, findsOneWidget);
    });
  });
}
