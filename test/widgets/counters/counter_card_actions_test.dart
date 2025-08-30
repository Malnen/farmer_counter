import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/widgets/counters/counter_card_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_mocks.dart';
import '../../test_material_app.dart';

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
      await tester.pumpAndSettle();

      // then:
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(find.byIcon(Icons.expand_less), findsNothing);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });
  });

  testWidgets('should expand and show actions', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      expect(find.byIcon(Icons.expand_less), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });
  });

  testWidgets('should open increase dialog and call callback', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '5');
      await tester.tap(find.text('common.save'.tr()));
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
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      await tester.tap(find.byIcon(Icons.arrow_downward));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '3');
      await tester.tap(find.text('common.save'.tr()));
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
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.tap(find.text('common.cancel'.tr()));
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
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // when:
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '0');
      await tester.tap(find.text('common.save'.tr()));
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      expect(find.text('counter_card.dialogs.amount_error'.tr()), findsOneWidget);
      verifyNever(() => onBulkAdjust.call(any()));
    });
  });
}
