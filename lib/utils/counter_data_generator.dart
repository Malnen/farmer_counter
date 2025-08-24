import 'dart:math';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';

class CounterDataGenerator {
  final Random random = Random();
  final Uuid uuid = const Uuid();
  final Isar isar;

  CounterDataGenerator(this.isar);
  Future<List<CounterItem>> generateCounters({
    required int itemCount,
    int years = 4,
  }) async {
    final List<CounterItem> items = <CounterItem>[];

    await isar.writeTxn(() async {
      for (int i = 0; i < itemCount; i++) {
        CounterItem item = CounterItem(
          guid: uuid.v4(),
          name: 'Counter ${i + 1}',
          count: 0,
          createdAt: DateTime.now().subtract(Duration(days: 365 * years)),
          id: Isar.autoIncrement,
        );

        final List<CounterChangeItem> changes = generateChangesForItem(item, years: years);
        final List<CounterItemNote> notes = generateNotesForItem(item, years: years);

        if (changes.isNotEmpty) {
          item = item.copyWith(count: changes.last.newValue);
        }

        await isar.counterItems.put(item);
        await isar.counterChangeItems.putAll(changes);
        await isar.counterItemNotes.putAll(notes);

        items.add(item);
      }
    });

    return items;
  }


  List<CounterChangeItem> generateChangesForItem(CounterItem item, {int years = 4}) {
    final List<CounterChangeItem> changes = <CounterChangeItem>[];
    DateTime start = item.createdAt;
    final DateTime now = DateTime.now();
    int currentValue = random.nextInt(500);
    while (start.isBefore(now)) {
      start = start.add(Duration(days: random.nextInt(14) + 1));
      if (start.isAfter(now)) break;

      final int delta = random.nextInt(200) - 50;
      currentValue += delta;

      if (currentValue < 0) currentValue = 0;
      if (currentValue > 10000) currentValue = 10000;

      changes.add(
        CounterChangeItem(
          id: Isar.autoIncrement,
          counterGuid: item.guid,
          at: start,
          delta: delta,
          newValue: currentValue,
        ),
      );
    }

    return changes;
  }

  List<CounterItemNote> generateNotesForItem(CounterItem item, {int years = 4}) {
    final List<CounterItemNote> notes = <CounterItemNote>[];
    DateTime start = item.createdAt;
    final DateTime now = DateTime.now();
    int idCounter = 1;

    while (start.isBefore(now)) {
      start = start.add(Duration(days: random.nextInt(60) + 15));
      if (start.isAfter(now)) break;

      notes.add(
        CounterItemNote(
          id: Isar.autoIncrement,
          counterGuid: item.guid,
          at: start,
          content: 'Note $idCounter for ${item.name}',
        ),
      );
      idCounter++;
    }

    return notes;
  }
}
