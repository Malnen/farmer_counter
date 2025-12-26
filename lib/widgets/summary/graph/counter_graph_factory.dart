import 'package:farmer_counter/enums/counter_chart_type.dart';
import 'package:farmer_counter/widgets/summary/graph/bar_counter_chart_builder.dart';
import 'package:farmer_counter/widgets/summary/graph/counter_graph_builder.dart';
import 'package:farmer_counter/widgets/summary/graph/line_counter_chart_builder.dart';

class CounterItemChartFactory {
  static CounterItemChartBuilder create(CounterChartType type) => switch (type) {
        CounterChartType.bar => BarCounterChartBuilder(),
        CounterChartType.line => LineCounterChartBuilder(),
      };
}
