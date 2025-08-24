import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/enums/date_range_preset.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_summary.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
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

    useEffect(
      () {
        final DateTimeRange<DateTime> range = selectedDateRange.toRange();
        loadCounterSummary(range.start, range.end);

        return null;
      },
      <Object?>[],
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
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (BuildContext context, bool loading, _) => Column(
                spacing: 8,
                children: <Widget>[
                  Text(
                    formatDateRange(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildStat('counter_summary_card.start'.tr(), counterSummary.value?.startValue, loading),
                      buildStat('counter_summary_card.end'.tr(), counterSummary.value?.endValue, loading),
                      buildStat('counter_summary_card.added'.tr(), counterSummary.value?.addedCount, loading),
                      buildStat('counter_summary_card.removed'.tr(), counterSummary.value?.removedCount, loading),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
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
          ],
        ),
      ),
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
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange:
          startDate.value != null && endDate.value != null ? DateTimeRange(start: startDate.value!, end: endDate.value!) : null,
    );
    if (picked != null) {
      selectedDateRange = DateRangeSelection.fromPreset(DateRangePreset.custom, customStart: picked.start, customEnd: picked.end);
      await loadCounterSummary(picked.start, picked.end);
    }
  }

  String formatDateRange() {
    if (startDate.value == null || endDate.value == null) {
      return '';
    }

    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return '${formatter.format(startDate.value!)} - ${formatter.format(endDate.value!)}';
  }

  Widget buildStat(String label, int? value, bool loading) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
          child: Center(
            child: loading
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    value?.toString() ?? '0',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
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
          final DateTimeRange range = selectedDateRange.toRange();
          await loadCounterSummary(range.start, range.end);
        }

        widget.onPresetChange?.call(selectedDateRange);
      },
      child: Text(
        label,
      ),
    );
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
      );
    }

    changes.sort((CounterChangeItem a, CounterChangeItem b) => a.at.compareTo(b.at));
    final int startValue = changes.first.newValue - changes.first.delta;
    final int endValue = changes.last.newValue;

    int added = 0;
    int removed = 0;

    for (final CounterChangeItem change in changes) {
      if (change.delta > 0) {
        added += change.delta;
      } else {
        removed += change.delta.abs();
      }
    }

    return CounterSummary(
      startValue: startValue,
      endValue: endValue,
      addedCount: added,
      removedCount: removed,
    );
  }
}
