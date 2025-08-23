import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/widgets/counters/counter_card.dart';
import 'package:farmer_counter/widgets/pages/counters_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';

void main() {
  late Widget app;

  setUp(() {
    app = TestMaterialApp(
      home: Scaffold(
        body: CountersPage(),
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
      final Finder countersPage = find.byType(CountersPage);
      expect(countersPage, findsOneWidget);
    });
  });

  testWidgets('should add item', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      final Finder name = find.byType(TextField);
      await tester.enterText(name, 'test');
      await tester.pumpAndSettle();
      final Finder add = find.text('counter_pages.dialogs.add_counter_dialog.counter_add_label'.tr());
      await tester.tap(add);
      await pumpEventQueue();
      await pumpEventQueue();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder cards = find.byType(CounterCard);
      expect(cards, findsOneWidget);
    });
  });

  testWidgets('should not add item', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      final Finder name = find.byType(TextField);
      await tester.enterText(name, 'test');
      await tester.pumpAndSettle();
      final Finder cancel = find.text('counter_pages.dialogs.add_counter_dialog.counter_cancel_label'.tr());
      await tester.tap(cancel);
      await pumpEventQueue();
      await pumpEventQueue();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder cards = find.byType(CounterCard);
      expect(cards, findsNothing);
    });
  });
}
