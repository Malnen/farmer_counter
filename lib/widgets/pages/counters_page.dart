import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/counters/counter_card.dart';
import 'package:farmer_counter/widgets/pages/counter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CountersPage extends HookWidget {
  const CountersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterCubit cubit = useMemoized(CounterCubit.new);
    useEffect(
      () => cubit.close,
      <Object?>[cubit],
    );

    return BlocProvider<CounterCubit>.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<CounterCubit, CounterState>(
                builder: (BuildContext context, CounterState state) {
                  if (state.status == CounterStatus.initial) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<CounterItem> items = state.items;
                  if (items.isEmpty) {
                    return Center(child: Text('counter_pages.no_items'.tr()));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final CounterItem item = items[index];
                      return InkWell(
                        splashFactory: NoSplash.splashFactory,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => CounterPage(
                              item: items[index],
                              onUpdate: cubit.updateItem,
                              onDelete: (CounterItem item) => cubit.removeItem(
                                item.guid,
                                afterDelete: () => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      tr('counter_details_page.snackbar.deleted', namedArgs: <String, String>{'name': item.name}),
                                    ),
                                    action: SnackBarAction(
                                      label: tr('counter_details_page.snackbar.ok'),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: CounterCard(
                          name: item.name,
                          count: item.count,
                          onMinus: () => cubit.decrement(item.guid),
                          onPlus: () => cubit.increment(item.guid),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context, cubit),
          tooltip: 'counter_pages.add_counter'.tr(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, CounterCubit cubit) async {
    final TextEditingController controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('counter_pages.add_counter'.tr()),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'counter_pages.dialogs.add_counter_dialog.counter_name_label'.tr(),
              hintText: 'counter_pages.dialogs.add_counter_dialog.counter_name_hint'.tr(),
            ),
            onSubmitted: (_) {
              final String name = controller.text.trim();
              if (name.isEmpty) {
                return;
              }

              cubit.addItem(name);
              controller.clear();
              Navigator.of(dialogContext).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.clear();
                Navigator.of(dialogContext).pop();
              },
              child: Text('counter_pages.dialogs.add_counter_dialog.counter_cancel_label'.tr()),
            ),
            FilledButton(
              onPressed: () {
                final String name = controller.text.trim();
                if (name.isEmpty) {
                  return;
                }

                cubit.addItem(name);
                controller.clear();
                Navigator.of(dialogContext).pop();
              },
              child: Text('counter_pages.dialogs.add_counter_dialog.counter_add_label'.tr()),
            ),
          ],
        );
      },
    );
  }
}
