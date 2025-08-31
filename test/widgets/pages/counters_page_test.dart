import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/widgets/counters/counter_card.dart';
import 'package:farmer_counter/widgets/pages/counters_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';

void main() {
  late Widget app;

  setUp(() {
    app = TestMaterialApp(
      home: Scaffold(
        body: BlocProvider<SettingsCubit>(
          create: (BuildContext context) => SettingsCubit(),
          child: const CountersPage(),
        ),
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
      final Finder add = find.text('counters_page.dialogs.add_counter_dialog.counter_add_label'.tr());
      await tester.tap(add);
      await pumpEventQueue();
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
      final Finder cancel = find.text('counters_page.dialogs.add_counter_dialog.counter_cancel_label'.tr());
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

  testWidgets('should show reverse button when history exists', (WidgetTester tester) async {
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
      await tester.enterText(name, 'withHistory');
      await tester.pumpAndSettle();
      final Finder add = find.text('counters_page.dialogs.add_counter_dialog.counter_add_label'.tr());
      await tester.tap(add);
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder plus = find.descendant(of: find.byType(CounterCard), matching:  find.byIcon(Icons.add));
      await tester.tap(plus);
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.ensureVisible(more);
      await tester.tap(more);
      await tester.pumpAndSettle();

      // then:
      final Finder reverse = find.byIcon(Icons.undo);
      expect(reverse, findsOneWidget);
    });
  });

  testWidgets('should open reverse delete dialog when tapped', (WidgetTester tester) async {
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
      await tester.enterText(name, 'withHistory');
      await tester.pumpAndSettle();
      final Finder add = find.text('counters_page.dialogs.add_counter_dialog.counter_add_label'.tr());
      await tester.tap(add);
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder plus = find.descendant(of: find.byType(CounterCard), matching:  find.byIcon(Icons.add));
      await tester.tap(plus);
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.ensureVisible(more);
      await tester.tap(more);
      await tester.pumpAndSettle();
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder reverse = find.byIcon(Icons.undo);
      await tester.ensureVisible(reverse);
      await tester.tap(reverse);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      final Finder title = find.text('counter_details_page.history.delete_title'.tr());
      expect(title, findsOneWidget);
    });
  });
}
