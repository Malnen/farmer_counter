import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/counters/counter_details_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late Widget app;
  late Isar isar;
  late CounterItem item;

  setUp(() async {
    isar = GetIt.instance.get<Isar>();
    item = CounterItem.create(name: 'HistoryTest');
    await isar.writeTxn(() async => isar.counterItems.put(item));
    app = TestMaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
          create: (BuildContext context) => ValueNotifier<CounterItem>(item),
          child: const CounterDetailsHistoryList(),
        ),
      ),
    );
  });

  testWidgets('should render empty state', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder historyList = find.byType(CounterDetailsHistoryList);
      await tester.waitForFinder(historyList);
      expect(historyList, findsOneWidget);
      final Finder noItems = find.text('counter_details_page.history.no_items'.tr());
      await tester.waitForFinder(noItems);
      expect(noItems, findsOneWidget);
    });
  });

  testWidgets('should render with history', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await isar.writeTxn(() async {
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: 1, newValue: 1),
        );
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: -1, newValue: 0),
        );
      });

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder historyList = find.byType(CounterDetailsHistoryList);
      await tester.waitForFinder(historyList);
      expect(historyList, findsOneWidget);
      final Finder tiles = find.byType(ListTile);
      await tester.waitForFinderCount(tiles, 2);
      expect(tiles, findsNWidgets(2));
    });
  });

  testWidgets('should reload when count changes', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      final ValueNotifier<CounterItem> notifier = ValueNotifier<CounterItem>(item);
      app = TestMaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
            create: (_) => notifier,
            child: const CounterDetailsHistoryList(),
          ),
        ),
      );
      await isar.writeTxn(
        () async => isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: 5, newValue: 5),
        ),
      );

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      Finder tiles = find.byType(ListTile);
      await tester.waitForFinder(tiles);
      expect(tiles, findsOneWidget);

      // when:
      await isar.writeTxn(
        () async => isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: 3, newValue: 8),
        ),
      );
      notifier.value = notifier.value.copyWith(count: 8);
      await tester.pump();
      await pumpEventQueue();

      // then:
      tiles = find.byType(ListTile);
      await tester.waitForFinder(tiles);
      expect(tiles, findsNWidgets(2));
    });
  });

  testWidgets('should show delete button and open dialog', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await isar.writeTxn(() async {
        await isar.counterChangeItems.put(
          CounterChangeItem.create(counterGuid: item.guid, delta: 2, newValue: 2),
        );
      });

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder delete = find.byIcon(Icons.delete);
      await tester.waitForFinder(delete);
      await tester.tap(delete);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder dialog = find.byType(AlertDialog);
      await tester.waitForFinder(dialog);
      expect(dialog, findsOneWidget);
      final Finder title = find.text('counter_details_page.history.delete_title'.tr());
      expect(title, findsOneWidget);
    });
  });
}
