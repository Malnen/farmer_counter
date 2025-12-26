import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item.dart';
import '../../tester_extension.dart';
import 'package:farmer_counter/widgets/pages/counter_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../test_material_app.dart';

void main() {
  late CounterItem item;
  late Widget app;

  CounterItem? updatedItem;

  setUp(() {
    item = CounterItem.create(name: 'TestCounter');
    updatedItem = null;
    app = TestMaterialApp(
      home: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
        create: (BuildContext context) => ValueNotifier<CounterItem>(item),
        child: CounterDetailsPage(
          onUpdate: (CounterItem item) async => updatedItem = item,
        ),
      ),
    );
  });

  testWidgets('should render details page', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();

      // then:
      final Finder page = find.byType(CounterDetailsPage);
      await tester.waitForFinder(page);
      expect(page, findsOneWidget);
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
      final Finder edit = find.byIcon(Icons.edit);
      await tester.waitForFinder(edit);
      await tester.tap(edit.first);
      final Finder textField = find.byType(TextField);
      await tester.waitForFinder(textField);
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
      final Finder edit = find.byIcon(Icons.edit);
      await tester.waitForFinder(edit);
      await tester.tap(edit.first);
      final Finder textField = find.byType(TextField);
      await tester.waitForFinder(textField);
      await tester.enterText(textField, 'IgnoredName');
      await tester.tap(find.text('counter_details_page.dialogs.edit_name.cancel'.tr()));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      expect(updatedItem, isNull);
    });
  });

  testWidgets('should edit count', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder editCount = find.byIcon(Icons.edit).last;
      await tester.tap(editCount);
      final Finder textField = find.byType(TextField);
      await tester.waitForFinder(textField);
      await tester.enterText(textField, '42');
      final Finder save = find.text('counter_details_page.dialogs.edit_count.save'.tr());
      await tester.tap(save);
      await tester.pump();
      await pumpEventQueue();
      await pumpEventQueue();

      // then:
      expect(updatedItem, isNotNull);
      expect(updatedItem!.count, 42);
    });
  });

  testWidgets('should cancel edit count', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.waitForFinder(find.byIcon(Icons.edit));
      final Finder editCount = find.byIcon(Icons.edit).last;
      await tester.tap(editCount);
      final Finder textField = find.byType(TextField);
      await tester.waitForFinder(textField);
      await tester.enterText(textField, '99');
      await tester.tap(find.text('counter_details_page.dialogs.edit_count.cancel'.tr()));
      await tester.pumpAndSettle();

      // then:
      expect(updatedItem, isNull);
    });
  });
}
