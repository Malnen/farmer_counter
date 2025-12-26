import 'package:farmer_counter/models/counter_chart_data.dart';
import 'package:flutter/material.dart';

mixin CounterItemChartBuilder {
  Widget build({
    required BuildContext context,
    required CounterChartData data,
    required double width,
    required double height,
    required bool showLeftTitles,
  });
}
