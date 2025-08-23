import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/counters/counter_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';

void main() {
  late CounterItem item;
  late Widget app;

  CounterItem? updatedItem;
  CounterItem? deletedItem;

  setUp(() {
    item = CounterItem.create(name: 'TestCounter');
    updatedItem = null;
    deletedItem = null;
    app = TestMaterialApp(
      home: CounterDetailsPage(
        item: item,
        onUpdate: (CounterItem ci) => updatedItem = ci,
        onDelete: (CounterItem ci) => deletedItem = ci,
      ),
    );
  });

  testWidgets('should render details page', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder page = find.byType(CounterDetailsPage);
      expect(page, findsOneWidget);
      final Finder appbarTitle = find.descendant(of: find.byType(AppBar), matching: find.text(item.name));
      expect(appbarTitle, findsOneWidget);
      final Finder cardNameLabel = find.text('${'counter_details_page.fields.name'.tr()}: ');
      expect(cardNameLabel, findsOneWidget);
      final Finder cardName = find.descendant(of: find.byType(Card), matching: find.text(item.name));
      expect(cardName, findsOneWidget);
      final Finder countLabel = find.text('${'counter_details_page.fields.count'.tr()}: ');
      expect(countLabel, findsOneWidget);
      final Finder count = find.text('0');
      expect(count, findsOneWidget);
      final Finder atLabel = find.text(DateFormat('yyyy-MM-dd HH:mm').format(item.createdAt));
      expect(atLabel, findsOneWidget);
    });
  });

  testWidgets('should edit name', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder edit = find.byIcon(Icons.edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      final Finder textField = find.byType(TextField);
      await tester.enterText(textField, 'UpdatedName');
      final Finder save = find.text('counter_details_page.dialogs.edit_name.save'.tr());
      await tester.tap(save);
      await tester.pumpAndSettle();

      // then:
      expect(updatedItem, isNotNull);
      expect(updatedItem!.name, 'UpdatedName');
    });
  });

  testWidgets('should cancel edit name', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder edit = find.byIcon(Icons.edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      final Finder textField = find.byType(TextField);
      await tester.enterText(textField, 'IgnoredName');
      await tester.tap(find.text('counter_details_page.dialogs.edit_name.cancel'.tr()));
      await tester.pumpAndSettle();

      // then:
      expect(updatedItem, isNull);
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
