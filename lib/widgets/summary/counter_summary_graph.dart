import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

class CounterSummaryGraph extends StatefulHookWidget {
  final DateRangeSelection selection;

  const CounterSummaryGraph({
    required this.selection,
  });

  @override
  State<CounterSummaryGraph> createState() => CounterSummaryGraphState();
}

class CounterSummaryGraphState extends State<CounterSummaryGraph> {
  late Isar isar;
  late ValueNotifier<CounterItem> item;
  late ValueNotifier<bool> isLoading;
  late ValueNotifier<List<CounterChangeItem>> changeItems;

  @override
  void initState() {
    super.initState();
    isar = GetIt.instance.get<Isar>();
  }

  @override
  Widget build(BuildContext context) {
    item = context.read();
    isLoading = useState<bool>(true);
    changeItems = useState<List<CounterChangeItem>>(<CounterChangeItem>[]);

    useEffect(
      () {
        loadData();
        return null;
      },
      <Object?>[widget.selection],
    );

    return SizedBox(
      height: 240,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (BuildContext context, bool loading, _) {
              if (loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (changeItems.value.isEmpty) {
                return Center(child: Text('counter_summary_graph.no_data'.tr()));
              }

              final List<BarChartGroupData> barGroups = <BarChartGroupData>[];
              for (int i = 0; i < changeItems.value.length; i++) {
                final CounterChangeItem change = changeItems.value[i];
                barGroups.add(
                  BarChartGroupData(
                    x: i,
                    barRods: <BarChartRodData>[
                      BarChartRodData(
                        toY: change.delta.toDouble(),
                        color: change.delta >= 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                );
              }

              return BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: max(1, (changeItems.value.length / 6).floor()).toDouble(),
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final int index = value.toInt();
                          if (index < 0 || index >= changeItems.value.length) {
                            return const SizedBox.shrink();
                          }
                          final DateTime date = changeItems.value[index].at;
                          return Text(
                            DateFormat.Md().format(date),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                  gridData: FlGridData(show: true),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    isLoading.value = true;
    final DateTimeRange range = widget.selection.toRange();
    final List<CounterChangeItem> results = await isar.counterChangeItems
        .filter()
        .counterGuidEqualTo(item.value.guid)
        .and()
        .atBetween(range.start, range.end)
        .findAll();

    results.sort((CounterChangeItem a, CounterChangeItem b) => a.at.compareTo(b.at));

    changeItems.value = results;
    isLoading.value = false;
  }
}
