import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/pages/counter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';

void main() {
  late Widget app;
  late CounterItem item;

  CounterItem? deletedItem;

  setUp(() {
    deletedItem = null;
    item = CounterItem.create(name: 'TestCounter');
    app = TestMaterialApp(
      home: Scaffold(
        body: CounterPage(
          item: item,
          onDelete: (CounterItem item) => deletedItem = item,
        ),
      ),
    );
  });

  testWidgets('should render', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder counterPage = find.byType(CounterPage);
      expect(counterPage, findsOneWidget);
      final Finder appbarTitle = find.descendant(of: find.byType(AppBar), matching: find.text(item.name));
      expect(appbarTitle, findsOneWidget);
    });
  });

  testWidgets('should delete item after confirm', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder deleteIcon = find.byIcon(Icons.delete);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();
      final Finder delete = find.text('counter_details_page.dialogs.delete_counter.delete'.tr());
      await tester.tap(delete);
      await tester.pumpAndSettle();

      // then:
      expect(deletedItem, isNotNull);
      expect(deletedItem!.guid, item.guid);
    });
  });

  testWidgets('should not delete item on cancel', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder deleteIcon = find.byIcon(Icons.delete);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();
      final Finder cancel = find.text('counter_details_page.dialogs.delete_counter.cancel'.tr());
      await tester.tap(cancel);
      await tester.pumpAndSettle();

      // then:
      expect(deletedItem, isNull);
    });
  });
}
