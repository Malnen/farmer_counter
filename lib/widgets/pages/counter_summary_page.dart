import 'package:farmer_counter/enums/date_range_preset.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
import 'package:farmer_counter/widgets/summary/counter_summary_card.dart';
import 'package:farmer_counter/widgets/summary/counter_summary_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterSummaryPage extends HookWidget {
  const CounterSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<DateRangeSelection> selection = useState<DateRangeSelection>(DateRangeSelection.fromPreset(DateRangePreset.today));
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CounterSummaryCard(
            initialSelection: selection.value,
            onPresetChange: (DateRangeSelection newSelection) => selection.value = newSelection,
          ),
          SizedBox(
            height: 300,
            child: CounterSummaryGraph(selection: selection.value),
          ),
        ],
      ),
    );
  }
}
