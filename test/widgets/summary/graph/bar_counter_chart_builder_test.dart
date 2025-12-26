import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_chart_data.dart';
import 'package:farmer_counter/widgets/summary/graph/bar_counter_chart_builder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_material_app.dart';
import '../../../tester_extension.dart';

void main() {
  late BarCounterChartBuilder builder;
  late CounterChartData chartData;
  late Widget app;

  setUp(() {
    builder = BarCounterChartBuilder();
    chartData = CounterChartData(
      items: <CounterChangeItem>[
        CounterChangeItem.create(
          counterGuid: 'a',
          delta: 5,
          newValue: 5,
          at: DateTime(2024, 1, 1),
        ),
        CounterChangeItem.create(
          counterGuid: 'a',
          delta: -3,
          newValue: 2,
          at: DateTime(2024, 1, 2),
        ),
      ],
      minY: -3,
      maxY: 5,
    );
    app = TestMaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) => builder.build(
            context: context,
            data: chartData,
            width: 300,
            height: 200,
            showLeftTitles: true,
          ),
        ),
      ),
    );
  });

  testWidgets('should render BarChart', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder chart = find.byType(BarChart);
      await tester.waitForFinder(chart);
      expect(chart, findsOneWidget);
    });
  });

  testWidgets('should render correct number of bars', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder barChartFinder = find.byType(BarChart);
      await tester.waitForFinder(barChartFinder);
      final BarChart barChart = tester.widget<BarChart>(barChartFinder);
      expect(barChart.data.barGroups.length, 2);
    });
  });

  testWidgets('should apply minY and maxY from chart data', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder barChartFinder = find.byType(BarChart);
      await tester.waitForFinder(barChartFinder);
      final BarChart barChart = tester.widget<BarChart>(barChartFinder);
      expect(barChart.data.minY, -3);
      expect(barChart.data.maxY, 5);
    });
  });

  testWidgets('should color positive and negative bars differently', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder barChartFinder = find.byType(BarChart);
      await tester.waitForFinder(barChartFinder);
      final BarChart barChart = tester.widget<BarChart>(barChartFinder);
      final BarChartRodData positiveRod = barChart.data.barGroups.first.barRods.first;
      expect(positiveRod.toY, 5);
      final BarChartRodData negativeRod = barChart.data.barGroups.last.barRods.first;
      expect(negativeRod.toY, -3);
      expect(positiveRod.color, isNot(negativeRod.color));
    });
  });

  testWidgets('should render bottom title labels', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder firstDate = find.text('1/1');
      await tester.waitForFinder(firstDate);
      expect(firstDate, findsOneWidget);
      final Finder secondDate = find.text('1/2');
      expect(secondDate, findsOneWidget);
    });
  });
}
