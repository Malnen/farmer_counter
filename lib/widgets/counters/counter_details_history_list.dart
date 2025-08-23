import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

class CounterDetailsHistoryList extends HookWidget {
  final CounterItem item;
  final int pageSize;

  const CounterDetailsHistoryList({
    required this.item,
    this.pageSize = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<CounterChangeItem>> history = useState<List<CounterChangeItem>>(<CounterChangeItem>[]);
    final ValueNotifier<bool> isLoading = useState(false);
    final ValueNotifier<bool> hasMore = useState(true);
    final ValueNotifier<int> offset = useState(0);
    final ScrollController scrollController = useScrollController();

    useEffect(
      () {
        _loadMore(history, isLoading, hasMore, offset);
        return null;
      },
      <Object?>[item.guid],
    );

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
          _loadMore(history, isLoading, hasMore, offset);
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, <Object?>[scrollController]);

    if (history.value.isEmpty && isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (history.value.isEmpty && !isLoading.value) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('counter_details_page.history.no_items'.tr()),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.builder(
        controller: scrollController,
        itemCount: history.value.length + (hasMore.value ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == history.value.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final CounterChangeItem change = history.value[index];
          return ListTile(
            leading: Icon(
              change.delta >= 0 ? Icons.add : Icons.remove,
              color: change.delta >= 0 ? Colors.green : Colors.red,
            ),
            title: Text(
              '${change.newValue}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('yyyy-MM-dd HH:mm').format(change.at),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadMore(
    ValueNotifier<List<CounterChangeItem>> history,
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> hasMore,
    ValueNotifier<int> offset,
  ) async {
    if (isLoading.value || !hasMore.value) {
      return;
    }

    isLoading.value = true;
    final Isar isar = GetIt.instance.get<Isar>();
    final List<CounterChangeItem> items = await isar.counterChangeItems
        .filter()
        .counterGuidEqualTo(item.guid)
        .sortByAtDesc()
        .offset(offset.value)
        .limit(
          pageSize,
        )
        .findAll();

    if (items.length < pageSize) {
      hasMore.value = false;
    }

    history.value = <CounterChangeItem>[...history.value, ...items];
    offset.value += items.length;
    isLoading.value = false;
  }
}
