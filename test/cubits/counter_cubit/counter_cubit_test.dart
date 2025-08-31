import 'package:bloc_test/bloc_test.dart';
import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

void main() {
  late Isar isar;
  Future<List<CounterChangeItem>> history(String guid) => isar.counterChangeItems.filter().counterGuidEqualTo(guid).findAll();

  setUp(() {
    isar = GetIt.instance.get();
  });

  blocTest<CounterCubit, CounterState>(
    'addItem ignores empty names after trim',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('   ');
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      final List<CounterItem> all = await isar.counterItems.where().findAll();
      expect(all, isEmpty);
      expect(cubit.state.items, isEmpty);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'addItem trims name, creates item and seeds history',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('  Cows  ');
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.name, 'Cows');
      final String guid = cubit.state.items.first.guid;
      final List<CounterChangeItem> currentHistory = await history(guid);
      expect(currentHistory.length, 0);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'increment updates count and appends +1 history',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Sheep');
      final String guid = cubit.state.items.first.guid;
      await cubit.increment(guid);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      final String guid = cubit.state.items.first.guid;
      final CounterItem updated = cubit.state.items.firstWhere((CounterItem item) => item.guid == guid);
      expect(updated.count, 1);
      final List<CounterChangeItem> currentHistory = await history(guid);
      expect(currentHistory.length, 1);
      expect(currentHistory.any((CounterChangeItem change) => change.delta == 1 && change.newValue == 1), isTrue);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'decrement updates count and appends -1 history',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Goats');
      final String guid = cubit.state.items.first.guid;
      await cubit.increment(guid);
      await cubit.decrement(guid);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      final String guid = cubit.state.items.first.guid;
      final CounterItem item = cubit.state.items.firstWhere((CounterItem item) => item.guid == guid);
      expect(item.count, 0);
      final List<CounterChangeItem> currentHistory = await history(guid);
      expect(currentHistory.length, 2);
      expect(currentHistory.any((CounterChangeItem change) => change.delta == -1 && change.newValue == 0), isTrue);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'decrements below 0',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Pigs');
      final String guid = cubit.state.items.first.guid;
      await cubit.decrement(guid);
      await cubit.decrement(guid);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      final String guid = cubit.state.items.first.guid;
      final CounterItem item = cubit.state.items.firstWhere((CounterItem item) => item.guid == guid);
      expect(item.count, -2);
      final List<CounterChangeItem> currentHistory = await history(guid);
      expect(currentHistory.length, 2);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'removeItem deletes the counter and all its history',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Chickens');
      final String guid = cubit.state.items.first.guid;
      await cubit.increment(guid);
      await cubit.increment(guid);
      await cubit.decrement(guid);
      await cubit.removeItem(guid);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      expect(cubit.state.items, isEmpty);
      final List<CounterItem> all = await isar.counterItems.where().findAll();
      expect(all, isEmpty);
      final List<CounterChangeItem> historyLeft = await isar.counterChangeItems.where().findAll();
      expect(historyLeft, isEmpty);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'cubit loads existing items on start',
    build: CounterCubit.new,
    setUp: () async {
      final CounterItem seeded = CounterItem.create(name: 'Seed');
      await isar.writeTxn(() async => isar.counterItems.put(seeded));
      await pumpEventQueue();
    },
    act: (CounterCubit cubit) async {
      await cubit.stream.firstWhere((CounterState s) => s.status == CounterStatus.loaded);
    },
    verify: (CounterCubit cubit) async {
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.name, 'Seed');
    },
  );

  blocTest<CounterCubit, CounterState>(
    'updateItem does nothing if guid does not exist',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      final CounterItem fake = CounterItem.create(name: 'Fake');
      await cubit.updateItem(fake);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      expect(cubit.state.items, isEmpty);
      final List<CounterItem> all = await isar.counterItems.where().findAll();
      expect(all, isEmpty);
    },
  );
  blocTest<CounterCubit, CounterState>(
    'updateItem updates name',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Original');
      final CounterItem existing = cubit.state.items.first;
      final CounterItem updated = existing.copyWith(name: 'Updated');
      await cubit.updateItem(updated);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.name, 'Updated');
      final List<CounterItem> all = await isar.counterItems.where().findAll();
      expect(all.length, 1);
      expect(all.first.name, 'Updated');
      final List<CounterChangeItem> currentHistory = await history(all.first.guid);
      expect(currentHistory.length, 0);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'updateItem updates count and appends history delta',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Counter');
      final CounterItem existing = cubit.state.items.first;
      final CounterItem updated = existing.copyWith(count: 10);
      await cubit.updateItem(updated);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.count, 10);
      final String guid = cubit.state.items.first.guid;
      final List<CounterItem> all = await isar.counterItems.where().findAll();
      expect(all.length, 1);
      expect(all.first.count, 10);
      final List<CounterChangeItem> currentHistory = await history(guid);
      expect(currentHistory.length, 1);
      expect(currentHistory.any((CounterChangeItem change) => change.delta == 10 && change.newValue == 10), isTrue);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'applyDelta updates count and appends history',
    build: CounterCubit.new,
    act: (CounterCubit counterCubit) async {
      await counterCubit.addItem('Horses');
      final String counterGuid = counterCubit.state.items.first.guid;
      await counterCubit.applyDelta(guid: counterGuid, delta: 5);
      await pumpEventQueue();
    },
    verify: (CounterCubit counterCubit) async {
      final String counterGuid = counterCubit.state.items.first.guid;
      final CounterItem updatedCounterItem =
          counterCubit.state.items.firstWhere((CounterItem counterItem) => counterItem.guid == counterGuid);
      expect(updatedCounterItem.count, 5);
      final List<CounterChangeItem> counterChangeHistory = await isar.counterChangeItems.filter().counterGuidEqualTo(counterGuid).findAll();
      expect(counterChangeHistory.length, 1);
      expect(
        counterChangeHistory.any((CounterChangeItem counterChangeItem) => counterChangeItem.delta == 5 && counterChangeItem.newValue == 5),
        isTrue,
      );
    },
  );

  blocTest<CounterCubit, CounterState>(
    'applyDelta with delta 0 does not append history',
    build: CounterCubit.new,
    act: (CounterCubit counterCubit) async {
      await counterCubit.addItem('ZeroDelta');
      final String counterGuid = counterCubit.state.items.first.guid;
      await counterCubit.applyDelta(guid: counterGuid, delta: 0);
      await pumpEventQueue();
    },
    verify: (CounterCubit counterCubit) async {
      final String counterGuid = counterCubit.state.items.first.guid;
      final CounterItem counterItem = counterCubit.state.items.firstWhere((CounterItem item) => item.guid == counterGuid);
      expect(counterItem.count, 0);
      final List<CounterChangeItem> counterChangeHistory = await isar.counterChangeItems.filter().counterGuidEqualTo(counterGuid).findAll();
      expect(counterChangeHistory.length, 0);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'deleteHistoryEntry removes latest change and updates counter value',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Dogs');
      final String guid = cubit.state.items.first.guid;
      await cubit.increment(guid);
      await cubit.increment(guid);
      await pumpEventQueue();

      final List<CounterChangeItem> before = await history(guid);
      final int changeId = before.last.id;
      await cubit.deleteHistoryEntry(guid, changeId);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      final String guid = cubit.state.items.first.guid;
      final CounterItem item = cubit.state.items.first;
      expect(item.count, 1);
      final List<CounterChangeItem> after = await history(guid);
      expect(after.length, 1);
      expect(after.single.newValue, 1);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'deleteHistoryEntry with invalid changeId does nothing',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Cats');
      final String guid = cubit.state.items.first.guid;
      await cubit.increment(guid);
      await pumpEventQueue();

      await cubit.deleteHistoryEntry(guid, 999999);
      await pumpEventQueue();
    },
    verify: (CounterCubit cubit) async {
      final String guid = cubit.state.items.first.guid;
      final CounterItem item = cubit.state.items.first;
      expect(item.count, 1);
      final List<CounterChangeItem> changes = await history(guid);
      expect(changes.length, 1);
    },
  );

  blocTest<CounterCubit, CounterState>(
    'getLatestChange returns most recent change',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('Parrots');
      final String guid = cubit.state.items.first.guid;
      await cubit.increment(guid);
      await cubit.increment(guid);
      await cubit.decrement(guid);
      await pumpEventQueue();

      final CounterChangeItem? latest = await cubit.getLatestChange(guid);
      expect(latest, isNotNull);
      expect(latest!.newValue, 1);
    },
    verify: (_) async {},
  );

  blocTest<CounterCubit, CounterState>(
    'getLatestChange returns null if no history',
    build: CounterCubit.new,
    act: (CounterCubit cubit) async {
      await cubit.addItem('NoHistory');
    },
    verify: (CounterCubit cubit) async {
      final String guid = cubit.state.items.first.guid;
      final CounterChangeItem? latest = await cubit.getLatestChange(guid);
      expect(latest, isNull);
    },
  );
}
