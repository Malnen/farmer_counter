import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/enums/date_range_preset.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:farmer_counter/extensions/summary_metric_extension.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_summary.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
import 'package:farmer_counter/widgets/summary/metric_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

class CounterSummaryCard extends StatefulHookWidget {
  final DateRangeSelection initialSelection;
  final void Function(DateRangeSelection selection)? onPresetChange;

  const CounterSummaryCard({required this.initialSelection, this.onPresetChange});

  @override
  State<CounterSummaryCard> createState() => CounterSummaryCardState();
}

class CounterSummaryCardState extends State<CounterSummaryCard> {
  late ValueNotifier<CounterItem> counterItem;
  late Isar isar;
  late ValueNotifier<DateTime?> startDate;
  late ValueNotifier<DateTime?> endDate;
  late ValueNotifier<CounterSummary?> counterSummary;
  late ValueNotifier<bool> isLoading;
  late DateRangeSelection selectedDateRange;
  late SettingsCubit settingsCubit;

  @override
  void initState() {
    super.initState();
    isar = GetIt.instance.get<Isar>();
    selectedDateRange = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    counterItem = context.read<ValueNotifier<CounterItem>>();
    startDate = useState(null);
    endDate = useState(null);
    counterSummary = useState(null);
    isLoading = useState(false);
    settingsCubit = context.read();

    useEffect(
      () {
        final DateTimeRange<DateTime> range = selectedDateRange.toRange();
        loadCounterSummary(range.start, range.end);
        return null;
      },
      const <Object?>[],
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              counterItem.value.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ValueListenableBuilder<CounterItem>(
              valueListenable: counterItem,
              builder: (_, CounterItem item, __) => Column(
                children: <Widget>[
                  Text(
                    item.count.toString(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'counter_summary_card.current'.tr(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (BuildContext context, bool loading, _) => Column(
                spacing: 8,
                children: <Widget>[
                  Text(
                    formatDateRange(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (counterSummary.value != null)
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.25,
                      children: SummaryMetric.values.where(settingsCubit.isSummaryMetricEnabled).map((SummaryMetric metric) {
                        final String displayValue = formatMetricValue(metric, counterSummary.value!, loading);
                        return MetricTile(
                          icon: metric.icon,
                          label: metric.label,
                          value: displayValue,
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: <Widget>[
                  buildPresetButton('counter_summary_card.today'.tr(), DateRangePreset.today),
                  buildPresetButton('counter_summary_card.last_week'.tr(), DateRangePreset.thisWeek),
                  buildPresetButton('counter_summary_card.last_month'.tr(), DateRangePreset.thisMonth),
                  buildPresetButton('counter_summary_card.three_months'.tr(), DateRangePreset.threeMonths),
                  buildPresetButton('counter_summary_card.six_months'.tr(), DateRangePreset.sixMonths),
                  buildPresetButton('counter_summary_card.last_year'.tr(), DateRangePreset.thisYear),
                  buildPresetButton('counter_summary_card.custom'.tr(), DateRangePreset.custom, isCustom: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatMetricValue(SummaryMetric metric, CounterSummary summary, bool loading) {
    if (loading) {
      return '...';
    }
    switch (metric) {
      case SummaryMetric.start:
        return summary.startValue.toString();
      case SummaryMetric.end:
        return summary.endValue.toString();
      case SummaryMetric.added:
        return summary.addedCount.toString();
      case SummaryMetric.removed:
        return summary.removedCount.toString();
      case SummaryMetric.difference:
        return summary.difference.toString();
      case SummaryMetric.percentChange:
        return summary.percentChange.toStringAsFixed(1);
      case SummaryMetric.averagePerDay:
        return summary.averagePerDay.toStringAsFixed(2);
      case SummaryMetric.averagePerDayAdded:
        return summary.averagePerDayAdded.toStringAsFixed(2);
      case SummaryMetric.averagePerDayRemoved:
        return summary.averagePerDayRemoved.toStringAsFixed(2);
      case SummaryMetric.maxValue:
        return summary.maxValue?.toString() ?? '0';
      case SummaryMetric.minValue:
        return summary.minValue?.toString() ?? '0';
    }
  }

  Widget buildPresetButton(String label, DateRangePreset preset, {bool isCustom = false}) {
    final bool isSelected = selectedDateRange.preset == preset;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? colorScheme.primary : colorScheme.surface,
        foregroundColor: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        side: BorderSide(color: colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () async {
        selectedDateRange = DateRangeSelection.fromPreset(preset, customStart: startDate.value, customEnd: endDate.value);
        if (isCustom) {
          await pickCustomDateRange();
        } else {
          final DateTimeRange<DateTime> range = selectedDateRange.toRange();
          await loadCounterSummary(range.start, range.end);
        }
        widget.onPresetChange?.call(selectedDateRange);
      },
      child: Text(label),
    );
  }

  Future<void> loadCounterSummary(DateTime start, DateTime end) async {
    isLoading.value = true;
    final CounterSummary summaryValue = await getCounterSummary(
      counter: counterItem.value,
      start: start,
      end: end,
    );
    startDate.value = start;
    endDate.value = end;
    counterSummary.value = summaryValue;
    isLoading.value = false;
  }

  Future<void> pickCustomDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange<DateTime>? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange:
          startDate.value != null && endDate.value != null ? DateTimeRange(start: startDate.value!, end: endDate.value!) : null,
    );
    if (picked != null) {
      selectedDateRange = DateRangeSelection.fromPreset(
        DateRangePreset.custom,
        customStart: picked.start,
        customEnd: picked.end,
      );
      await loadCounterSummary(picked.start, picked.end);
    }
  }

  String formatDateRange() {
    if (startDate.value == null || endDate.value == null) return '';
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return '${formatter.format(startDate.value!)} - ${formatter.format(endDate.value!)}';
  }

  Future<CounterSummary> getCounterSummary({
    required CounterItem counter,
    required DateTime start,
    required DateTime end,
  }) async {
    final List<CounterChangeItem> changes =
        await isar.counterChangeItems.filter().counterGuidEqualTo(counter.guid).and().atBetween(start, end).findAll();

    if (changes.isEmpty) {
      return CounterSummary(
        startValue: counter.count,
        endValue: counter.count,
        addedCount: 0,
        removedCount: 0,
        difference: 0,
        percentChange: 0,
        averagePerDay: 0,
        averagePerDayAdded: 0,
        averagePerDayRemoved: 0,
        maxValue: counter.count,
        minValue: counter.count,
      );
    }

    changes.sort((CounterChangeItem a, CounterChangeItem b) => a.at.compareTo(b.at));
    final int startValue = changes.first.newValue - changes.first.delta;
    final int endValue = changes.last.newValue;

    int added = 0;
    int removed = 0;
    int maxValue = startValue;
    int minValue = startValue;

    for (final CounterChangeItem change in changes) {
      if (change.delta > 0) {
        added += change.delta;
      } else {
        removed += change.delta.abs();
      }
      if (change.newValue > maxValue) maxValue = change.newValue;
      if (change.newValue < minValue) minValue = change.newValue;
    }

    final int difference = endValue - startValue;
    final num percentChange = startValue == 0 ? 0 : (difference / startValue) * 100.0;
    final int days = end.difference(start).inDays.abs();
    final double averagePerDay = days == 0 ? difference.toDouble() : difference / days;
    final double averagePerDayAdded = days == 0 ? added.toDouble() : added / days;
    final double averagePerDayRemoved = days == 0 ? removed.toDouble() : removed / days;

    return CounterSummary(
      startValue: startValue,
      endValue: endValue,
      addedCount: added,
      removedCount: removed,
      difference: difference,
      percentChange: percentChange,
      averagePerDay: averagePerDay,
      averagePerDayAdded: averagePerDayAdded,
      averagePerDayRemoved: averagePerDayRemoved,
      maxValue: maxValue,
      minValue: minValue,
    );
  }
}
