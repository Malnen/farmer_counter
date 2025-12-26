import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_chart_data.dart';
import 'package:farmer_counter/widgets/summary/graph/line_counter_chart_builder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_material_app.dart';
import '../../../tester_extension.dart';

void main() {
  late LineCounterChartBuilder builder;
  late CounterChartData chartData;
  late Widget app;

  setUp(() {
    builder = LineCounterChartBuilder();
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

  testWidgets('should render LineChart', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder chart = find.byType(LineChart);
      await tester.waitForFinder(chart);
      expect(chart, findsOneWidget);
    });
  });

  testWidgets('should render correct number of spots', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder lineChartFinder = find.byType(LineChart);
      await tester.waitForFinder(lineChartFinder);
      final LineChart lineChart = tester.widget<LineChart>(lineChartFinder);
      final List<LineChartBarData> bars = lineChart.data.lineBarsData;
      expect(bars.length, 1);
      final List<FlSpot> spots = bars.first.spots;
      expect(spots.length, 2);
      expect(spots[0].x, 0);
      expect(spots[0].y, 5);
      expect(spots[1].x, 1);
      expect(spots[1].y, -3);
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
      final Finder lineChartFinder = find.byType(LineChart);
      await tester.waitForFinder(lineChartFinder);
      final LineChart lineChart = tester.widget<LineChart>(lineChartFinder);
      expect(lineChart.data.minY, -3);
      expect(lineChart.data.maxY, 5);
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
      final Finder lineChartFinder = find.byType(LineChart);
      await tester.waitForFinder(lineChartFinder);
      final Finder firstDate = find.text('1/1');
      expect(firstDate, findsOneWidget);
      final Finder secondDate = find.text('1/2');
      expect(secondDate, findsOneWidget);
    });
  });

  testWidgets('should hide dots on line chart', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder lineChartFinder = find.byType(LineChart);
      await tester.waitForFinder(lineChartFinder);
      final LineChart lineChart = tester.widget<LineChart>(lineChartFinder);
      final LineChartBarData bar = lineChart.data.lineBarsData.first;
      expect(bar.dotData.show, isFalse);
    });
  });
}
