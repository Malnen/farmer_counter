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

void main() {
  late Widget app;
  late Isar isar;
  late CounterItem item;

  setUp(() async {
    isar = GetIt.instance.get<Isar>();
    item = CounterItem.create(name: 'HistoryTest');
    await isar.writeTxn(() async {
      await isar.counterItems.put(item);
    });

    app = TestMaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
          create: (BuildContext context) => ValueNotifier<CounterItem>(item),
          child: CounterDetailsHistoryList(),
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
      await tester.pumpAndSettle();

      // then:
      final Finder historyList = find.byType(CounterDetailsHistoryList);
      expect(historyList, findsOneWidget);
      final Finder noItems = find.text('counter_details_page.history.no_items'.tr());
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
      await tester.pumpAndSettle();

      // then:
      final Finder historyList = find.byType(CounterDetailsHistoryList);
      expect(historyList, findsOneWidget);
      final Finder tiles = find.byType(ListTile);
      expect(tiles, findsNWidgets(2));
    });
  });
}
