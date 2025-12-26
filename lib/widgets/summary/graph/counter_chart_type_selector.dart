import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/enums/counter_chart_type.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterChartTypeSelector extends StatelessWidget {
  final CounterItem item;

  const CounterChartTypeSelector({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<CounterChartType>(
      segments: _segments(),
      selected: <CounterChartType>{item.lastSelectedChartType},
      onSelectionChanged: (Set<CounterChartType> selection) {
        final CounterChartType type = selection.first;
        if (type != item.lastSelectedChartType) {
          final CounterCubit cubit = context.read<CounterCubit>();
          cubit.updateItem(
            item.copyWith(lastSelectedChartType: type),
          );
        }
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Icon _iconForType(CounterChartType type) => switch (type) {
        CounterChartType.bar => const Icon(Icons.bar_chart, size: 18),
        CounterChartType.line => const Icon(Icons.show_chart, size: 18)
      };

  List<ButtonSegment<CounterChartType>> _segments() => CounterChartType.values
      .map(
        (CounterChartType type) => ButtonSegment<CounterChartType>(
          value: type,
          icon: _iconForType(type),
        ),
      )
      .toList();
}
