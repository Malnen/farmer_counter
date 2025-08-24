import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/pages/counter_summary_page.dart';
import 'package:farmer_counter/widgets/summary/counter_summary_card.dart';
import 'package:farmer_counter/widgets/summary/counter_summary_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../test_material_app.dart';

void main() {
  late Widget app;

  setUp(() {
    app = TestMaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
          create: (BuildContext context) => ValueNotifier<CounterItem>(CounterItem.create(name: 'Test')),
          child: CounterSummaryPage(),
        ),
      ),
    );
  });

  testWidgets('should render summary card and graph', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder page = find.byType(CounterSummaryPage);
      expect(page, findsOneWidget);
      final Finder card = find.byType(CounterSummaryCard);
      expect(card, findsOneWidget);
      final Finder graph = find.byType(CounterSummaryGraph);
      expect(graph, findsOneWidget);
    });
  });
}
