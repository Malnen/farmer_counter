import 'package:farmer_counter/widgets/summary/metric_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders MetricTile with icon, value, and label', (WidgetTester tester) async {
    // given:
    const IconData testIcon = Icons.add;
    const String testValue = '42';
    const String testLabel = 'Added';

    // when:
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MetricTile(
            icon: testIcon,
            value: testValue,
            label: testLabel,
          ),
        ),
      ),
    );

    // then:
    final Finder value = find.text(testValue);
    expect(value, findsOneWidget);
    final Finder label = find.text(testLabel);
    expect(label, findsOneWidget);
    final Finder icon = find.byIcon(testIcon);
    expect(icon, findsOneWidget);
  });
}
