import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_community/isar.dart';

class CounterCubit extends Cubit<CounterState> {
  final Isar isar;

  CounterCubit(this.isar) : super(const CounterState(items: <CounterItem>[])) {
    _loadItems();
  }

  Future<void> _loadItems() async {
    final List<CounterItem> items = await isar.counterItems.where().findAll();
    emit(state.copyWith(items: items, status: CounterStatus.loaded));
  }

  Future<void> addItem(String name) async {
    name = name.trim();
    if (name.isEmpty) {
      return;
    }

    final CounterItem item = CounterItem.create(name: name);
    await isar.writeTxn(() async {
      await isar.counterItems.put(item);
    });

    emit(state.copyWith(items: <CounterItem>[...state.items, item]));
  }

  Future<void> removeItem(String guid) async {
    final CounterItem? item = await isar.counterItems.filter().guidEqualTo(guid).findFirst();
    if (item != null) {
      await isar.writeTxn(() async {
        await isar.counterItems.delete(item.id);
      });
      emit(state.copyWith(items: state.items.where((CounterItem i) => i.guid != guid).toList()));
    }
  }

  Future<void> increment(String guid) async {
    final CounterItem? item = await isar.counterItems.filter().guidEqualTo(guid).findFirst();
    if (item != null) {
      final CounterItem updated = item.copyWith(count: item.count + 1);
      await isar.writeTxn(() async {
        await isar.counterItems.put(updated);
      });
      emit(state.copyWith(items: state.items.map((CounterItem i) => i.guid == guid ? updated : i).toList()));
    }
  }

  Future<void> decrement(String guid) async {
    final CounterItem? item = await isar.counterItems.filter().guidEqualTo(guid).findFirst();
    if (item != null) {
      final CounterItem updated = item.copyWith(count: item.count > 0 ? item.count - 1 : 0);
      await isar.writeTxn(() async {
        await isar.counterItems.put(updated);
      });
      emit(
        state.copyWith(
          items: state.items.map((CounterItem i) => i.guid == guid ? updated : i).toList(),
        ),
      );
    }
  }
}
