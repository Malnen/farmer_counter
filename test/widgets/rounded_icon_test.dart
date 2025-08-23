import 'package:farmer_counter/widgets/round_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common_mocks.dart';

void main() {
  late Widget app;
  late MockFunction onTap;

  setUp(() {
    onTap = MockFunction();
    app = MaterialApp(
      home: Scaffold(
        body: RoundIcon(
          onTap: onTap.call,
          icon: Icons.add,
        ),
      ),
    );
  });

  testWidgets('should render', (WidgetTester tester) async {
    // given:
    // when:
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // then:
    final Finder roundIcon = find.byType(RoundIcon);
    expect(roundIcon, findsOneWidget);
    final Finder icon = find.byIcon(Icons.add);
    expect(icon, findsOneWidget);
  });

  testWidgets('should call onTap', (WidgetTester tester) async {
    // given:
    // when:
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    final Finder roundIcon = find.byType(RoundIcon);
    await tester.tap(roundIcon);

    // then:
    verify(onTap.call);
  });
}
