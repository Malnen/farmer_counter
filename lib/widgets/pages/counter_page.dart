import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/bottom_navigation_bar/scale_aware_bottom_bar.dart';
import 'package:farmer_counter/widgets/pages/counter_details_page.dart';
import 'package:farmer_counter/widgets/pages/counter_notes_page.dart';
import 'package:farmer_counter/widgets/pages/counter_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:provider/provider.dart';

class CounterPage extends HookWidget {
  final CounterItem item;
  final Future<void> Function(CounterItem item)? onUpdate;
  final void Function(CounterItem item)? onDelete;

  const CounterPage({
    required this.item,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<CounterItem> itemNotifier = useState(item);
    final CounterCubit counterCubit = context.read();
    useBlocListener(counterCubit, (CounterCubit bloc, CounterState state, BuildContext context) {
      final CounterItem? counterItem = state.items.firstWhereOrNull((CounterItem item) => item.guid == itemNotifier.value.guid);
      if (counterItem != null) {
        itemNotifier.value = counterItem;
      }
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(itemNotifier.value.name),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(context, itemNotifier),
            ),
          ],
        ),
        body: ChangeNotifierProvider<ValueNotifier<CounterItem>>.value(
          value: itemNotifier,
          child: TabBarView(
            children: <Widget>[
              CounterSummaryPage(),
              CounterNotesPage(),
              CounterDetailsPage(
                onUpdate: onUpdate,
                onDelete: onDelete,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.outlineVariant,
          child: ScaleAwareBottomBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.auto_graph_outlined), text: 'counter_page.summary_tab_title'.tr()),
              Tab(icon: Icon(Icons.event_note_outlined), text: 'counter_page.notes_tab_title'.tr()),
              Tab(icon: Icon(Icons.info), text: 'counter_page.details_tab_title'.tr()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteItem(BuildContext context, ValueNotifier<CounterItem> itemNotifier) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('counter_details_page.dialogs.delete_counter.title'.tr()),
        content: Text('counter_details_page.dialogs.delete_counter.message'.tr()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('counter_details_page.dialogs.delete_counter.cancel'.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text('counter_details_page.dialogs.delete_counter.delete'.tr()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onDelete?.call(itemNotifier.value);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
