import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/utils/counter_data_generator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

void main() {
  late Isar isar;
  late CounterDataGenerator generator;

  setUp(() {
    isar = GetIt.instance.get<Isar>();
    generator = CounterDataGenerator(isar);
  });

  test('generateCounters creates requested number of counters', () async {
    // given:
    const int itemCount = 3;

    // when:
    final List<CounterItem> items = await generator.generateCounters(itemCount: itemCount);

    // then:
    expect(items.length, itemCount);
    final int dbCount = await isar.counterItems.where().count();
    expect(dbCount, itemCount);
  });

  test('generateChangesForItem produces valid changes', () async {
    // given:
    final CounterItem item = CounterItem(
      guid: 'guid-123',
      name: 'Test Item',
      count: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      id: Isar.autoIncrement,
    );

    // when:
    final List<CounterChangeItem> changes = generator.generateChangesForItem(item, years: 1);

    // then:
    expect(changes.every((CounterChangeItem itemChange) => itemChange.counterGuid == item.guid), isTrue);
    expect(
      changes.every((CounterChangeItem itemChange) => itemChange.newValue >= 0 && itemChange.newValue <= 10000),
      isTrue,
    );
  });

  test('generateNotesForItem produces valid notes', () async {
    // given:
    final CounterItem item = CounterItem(
      guid: 'guid-456',
      name: 'Test Item Notes',
      count: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      id: Isar.autoIncrement,
    );

    // when:
    final List<CounterItemNote> notes = generator.generateNotesForItem(item, years: 1);

    // then:
    expect(notes.every((CounterItemNote note) => note.counterGuid == item.guid), isTrue);
    expect(notes.every((CounterItemNote note) => note.content.contains(item.name)), isTrue);
  });
}
