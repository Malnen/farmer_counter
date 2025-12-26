import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/widgets/counters/counter_card_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_mocks.dart';
import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late Widget app;
  late MockFunctionWithValue<int> onBulkAdjust;

  setUp(() {
    onBulkAdjust = MockFunctionWithValue<int>();
    app = TestMaterialApp(
      home: Scaffold(
        body: CounterCardActions(onBulkAdjust: onBulkAdjust.call),
      ),
    );
  });

  testWidgets('should render collapsed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      expect(more, findsOneWidget);
      final Finder less = find.byIcon(Icons.expand_less);
      expect(less, findsNothing);
      final Finder up = find.byIcon(Icons.arrow_upward);
      expect(up, findsOneWidget);
      final Finder down = find.byIcon(Icons.arrow_downward);
      expect(down, findsOneWidget);
    });
  });

  testWidgets('should expand and show actions', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // when:
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.tap(more);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder less = find.byIcon(Icons.expand_less);
      await tester.waitForFinder(less);
      expect(less, findsOneWidget);
      final Finder up = find.byIcon(Icons.arrow_upward);
      expect(up, findsOneWidget);
      final Finder down = find.byIcon(Icons.arrow_downward);
      expect(down, findsOneWidget);
    });
  });

  testWidgets('should open increase dialog and call callback', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.tap(more);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      final Finder up = find.byIcon(Icons.arrow_upward);
      await tester.waitForFinder(up);
      await tester.tap(up);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder textField = find.byType(TextFormField);
      await tester.waitForFinder(textField);
      await tester.enterText(textField, '5');
      final Finder save = find.text('common.save'.tr());
      await tester.waitForFinder(save);
      await tester.tap(save);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      verify(() => onBulkAdjust.call(5)).called(1);
    });
  });

  testWidgets('should open decrease dialog and call callback with negative', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.tap(more);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      final Finder down = find.byIcon(Icons.arrow_downward);
      await tester.waitForFinder(down);
      await tester.tap(down);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder textfield = find.byType(TextFormField);
      await tester.waitForFinder(textfield);
      await tester.enterText(textfield, '3');
      final Finder save = find.text('common.save'.tr());
      await tester.waitForFinder(save);
      await tester.tap(save);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      verify(() => onBulkAdjust.call(-3)).called(1);
    });
  });

  testWidgets('should not call callback when cancelled', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.tap(more);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      final Finder up = find.byIcon(Icons.arrow_upward);
      await tester.waitForFinder(up);
      await tester.tap(up);
      await tester.pump();
      await pumpEventQueue();
      final Finder cancel = find.text('common.cancel'.tr());
      await tester.waitForFinder(cancel);
      await tester.tap(cancel);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      verifyNever(() => onBulkAdjust.call(any()));
    });
  });

  testWidgets('should show validation error for invalid input', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.tap(more);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      final Finder up = find.byIcon(Icons.arrow_upward);
      await tester.waitForFinder(up);
      await tester.tap(up);
      await tester.pump();
      await pumpEventQueue();
      final Finder textfield = find.byType(TextFormField);
      await tester.waitForFinder(textfield);
      await tester.enterText(textfield, '0');
      final Finder save = find.text('common.save'.tr());
      await tester.waitForFinder(save);
      await tester.tap(save);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder error = find.text('counter_card.dialogs.amount_error'.tr());
      await tester.waitForFinder(error);
      expect(error, findsOneWidget);
      verifyNever(() => onBulkAdjust.call(any()));
    });
  });

  testWidgets('should call reverse callback when pressed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      final MockFunction mockReverse = MockFunction();
      app = TestMaterialApp(
        home: Scaffold(
          body: CounterCardActions(
            onBulkAdjust: onBulkAdjust.call,
            onReverseLast: mockReverse.call,
          ),
        ),
      );

      await tester.pumpWidget(app);
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.tap(more);
      await tester.pumpAndSettle();

      // when:
      final Finder undo = find.byIcon(Icons.undo);
      await tester.waitForFinder(undo);
      await tester.tap(undo);
      await tester.pumpAndSettle();

      // then:
      verify(mockReverse.call).called(1);
    });
  });
}
