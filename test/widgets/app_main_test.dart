import 'package:farmer_counter/widgets/app_main.dart';
import 'package:farmer_counter/widgets/counters/counter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should render', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      final Widget app = AppMain();

      // when:
      await tester.pumpWidget(app);
      await pumpEventQueue();

      // then:
      final Finder appMain = find.byType(AppMain);
      expect(appMain, findsOneWidget);
      final Finder counterPage = find.byType(CounterPage);
      expect(counterPage, findsOneWidget);
    });
  });
}
