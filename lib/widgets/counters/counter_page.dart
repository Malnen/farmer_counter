import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/counters/counter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterPage extends HookWidget {
  const CounterPage({super.key});

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
                    return const Center(child: Text('No items'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final CounterItem item = items[index];
                      return Dismissible(
                        key: Key(item.guid),
                        background: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.delete),
                        ),
                        secondaryBackground: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (_) => cubit.removeItem(item.guid),
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
          tooltip: 'Add counter',
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
          title: const Text('Add counter'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Apples',
            ),
            onSubmitted: (_) {
              final String name = controller.text.trim();
              if (name.isEmpty) return;
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
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String name = controller.text.trim();
                if (name.isEmpty) return;
                cubit.addItem(name);
                controller.clear();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
