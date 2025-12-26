import 'package:farmer_counter/models/counter_change_item.dart';

class CounterChartData {
  final List<CounterChangeItem> items;
  final double minY;
  final double maxY;

  const CounterChartData({
    required this.items,
    required this.minY,
    required this.maxY,
  });
}
