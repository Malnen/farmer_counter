import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_chart_data.dart';
import 'package:farmer_counter/widgets/summary/graph/counter_graph_builder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarCounterChartBuilder implements CounterItemChartBuilder {
  @override
  Widget build({
    required BuildContext context,
    required CounterChartData data,
    required double width,
    required double height,
    required bool showLeftTitles,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<BarChartGroupData> barGroups = <BarChartGroupData>[];
    for (int i = 0; i < data.items.length; i++) {
      final CounterChangeItem changeItem = data.items[i];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: <BarChartRodData>[
            BarChartRodData(
              toY: changeItem.delta.toDouble(),
              color: changeItem.delta >= 0 ? colorScheme.primary : colorScheme.error,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: BarChart(
        BarChartData(
          minY: data.minY,
          maxY: data.maxY,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: showLeftTitles),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: max(1, (data.items.length / 6).floor()).toDouble(),
                getTitlesWidget: (double value, _) {
                  final int index = value.toInt();
                  if (index < 0 || index >= data.items.length) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    DateFormat.Md().format(data.items[index].at),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
