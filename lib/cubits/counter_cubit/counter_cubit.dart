import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

class CounterCubit extends Cubit<CounterState> {
  Isar _isar;
  final DriveSyncService syncService;

  CounterCubit({Isar? isar, DriveSyncService? syncService})
      : _isar = isar ?? GetIt.instance.get(),
        syncService = syncService ?? GetIt.instance.get(),
        super(const CounterState(items: <CounterItem>[])) {
    _loadItems();
    this.syncService.isarNotifier.addListener(() {
      if (!isClosed) {
        _isar = this.syncService.isarNotifier.value;
        _loadItems();
      }
    });
  }

  @override
  Future<void> close() async {
    syncService.isarNotifier.removeListener(_loadItems);
    await super.close();
  }

  Future<void> addItem(String name) async {
    name = name.trim();
    if (name.isEmpty) {
      return;
    }

    CounterItem item = CounterItem.create(name: name);
    await _isar.writeTxn(() async {
      await _isar.counterItems.put(item);
      await _isar.counterChangeItems.put(
        CounterChangeItem.create(
          counterGuid: item.guid,
          delta: 0,
          newValue: item.count,
        ),
      );
    });

    item = (await _isar.counterItems.getByGuid(item.guid))!;
    emit(state.copyWith(items: <CounterItem>[...state.items, item]));
  }

  Future<void> removeItem(String guid, {VoidCallback? afterDelete}) async {
    final CounterItem? item = await _isar.counterItems.filter().guidEqualTo(guid).findFirst();
    if (item != null) {
      await _isar.writeTxn(() async {
        await _isar.counterItems.delete(item.id);
        await _isar.counterChangeItems.where().counterGuidEqualToAnyAt(guid).deleteAll();
      });
      emit(state.copyWith(items: state.items.where((CounterItem item) => item.guid != guid).toList()));
      afterDelete?.call();
    }
  }

  Future<void> updateItem(CounterItem updatedItem) async {
    final CounterItem? existing = await _isar.counterItems.filter().guidEqualTo(updatedItem.guid).findFirst();
    if (existing == null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.counterItems.put(updatedItem);
      if (existing.count != updatedItem.count) {
        final int delta = updatedItem.count - existing.count;
        final CounterChangeItem change = CounterChangeItem.create(
          counterGuid: updatedItem.guid,
          delta: delta,
          newValue: updatedItem.count,
        );

        await _isar.counterChangeItems.put(change);
      }
    });
    emit(
      state.copyWith(
        items: state.items.map((CounterItem item) => item.guid == updatedItem.guid ? updatedItem : item).toList(),
      ),
    );
  }

  Future<void> increment(String guid) => _applyDelta(guid, 1);

  Future<void> decrement(String guid) => _applyDelta(guid, -1);

  Future<void> _loadItems() async {
    final List<CounterItem> items = await _isar.counterItems.where().findAll();
    emit(state.copyWith(items: items, status: CounterStatus.loaded));
  }

  Future<void> _applyDelta(String guid, int delta) async {
    final CounterItem? item = await _isar.counterItems.filter().guidEqualTo(guid).findFirst();
    if (item == null) {
      return;
    }

    final int raw = item.count + delta;
    final int newCount = raw < 0 ? 0 : raw;
    final int actualDelta = newCount - item.count;

    if (actualDelta == 0) {
      return;
    }

    final CounterItem updated = item.copyWith(count: newCount);

    await _isar.writeTxn(() async {
      await _isar.counterItems.put(updated);
      await _isar.counterChangeItems.put(
        CounterChangeItem.create(
          counterGuid: item.guid,
          delta: actualDelta,
          newValue: newCount,
        ),
      );
    });

    emit(
      state.copyWith(
        items: state.items.map((CounterItem item) => item.guid == guid ? updated : item).toList(),
      ),
    );
  }
}
