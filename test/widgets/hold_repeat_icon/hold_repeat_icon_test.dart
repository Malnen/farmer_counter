import 'package:farmer_counter/widgets/hold_repeat_icon/hold_repeat_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_mocks.dart';

void main() {
  testWidgets('should render icon with correct size', (WidgetTester tester) async {
    // given:
    const double iconSize = 20.0;
    const double hitboxSize = 40.0;
    final MockFunction onStep = MockFunction();

    // when:
    await tester.pumpWidget(
      MaterialApp(
        home: HoldRepeatIcon(
          icon: Icons.add,
          iconSize: iconSize,
          hitboxSize: hitboxSize,
          onStep: onStep.call,
        ),
      ),
    );

    // then:
    final Finder holdRepeatIcon = find.byType(HoldRepeatIcon);
    final Finder iconWidget = find.descendant(
      of: holdRepeatIcon,
      matching: find.byType(Icon),
    );
    expect(iconWidget, findsOneWidget);
    final Icon icon = tester.widget<Icon>(iconWidget);
    expect(icon.icon, Icons.add);
    expect(icon.size, iconSize);
    final Finder hitboxWidget = find.descendant(
      of: holdRepeatIcon,
      matching: find.byWidgetPredicate(
        (Widget widget) => widget is SizedBox && widget.width == hitboxSize && widget.height == hitboxSize,
      ),
    );
    expect(hitboxWidget, findsOneWidget);
    final SizedBox box = tester.widget<SizedBox>(hitboxWidget);
    expect(box.width, hitboxSize);
    expect(box.height, hitboxSize);
  });

  testWidgets('should call onStep on tap', (WidgetTester tester) async {
    // given:
    final MockFunction onStep = MockFunction();
    await tester.pumpWidget(
      MaterialApp(
        home: HoldRepeatIcon(
          icon: Icons.add,
          onStep: onStep.call,
        ),
      ),
    );

    // when:
    final Finder holdIcon = find.byType(HoldRepeatIcon);
    await tester.tap(holdIcon);
    await tester.pump();

    // then:
    verify(onStep.call).called(1);
  });

  testWidgets('should call onStep while holding', (WidgetTester tester) async {
    // given:
    final MockFunction onStep = MockFunction();
    await tester.pumpWidget(
      MaterialApp(
        home: HoldRepeatIcon(
          icon: Icons.add,
          onStep: onStep.call,
        ),
      ),
    );
    final Finder holdIcon = find.byType(HoldRepeatIcon);
    final Offset center = tester.getCenter(holdIcon);
    final TestGesture gesture = await tester.startGesture(center);

    // when:
    await tester.pump(const Duration(milliseconds: 250));

    // then:
    verify(onStep.call).called(greaterThanOrEqualTo(1));
    await gesture.up();
  });

  testWidgets('should stop calling onStep after release', (WidgetTester tester) async {
    // given:
    final MockFunction onStep = MockFunction();
    await tester.pumpWidget(
      MaterialApp(
        home: HoldRepeatIcon(
          icon: Icons.add,
          onStep: onStep.call,
        ),
      ),
    );

    final Finder holdIcon = find.byType(HoldRepeatIcon);
    final Offset center = tester.getCenter(holdIcon);
    final TestGesture gesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.up();
    verify(onStep.call).called(greaterThanOrEqualTo(1));
    clearInteractions(onStep);

    // when:
    await tester.pump(const Duration(milliseconds: 200));

    // then:
    verifyNever(onStep.call);
  });
}
