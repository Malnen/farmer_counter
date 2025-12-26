import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/widgets/counters/counter_card.dart';
import 'package:farmer_counter/widgets/pages/counters_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

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

      // then:
      final Finder countersPage = find.byType(CountersPage);
      await tester.waitForFinder(countersPage);
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
      final Finder fab = find.byType(FloatingActionButton);
      await tester.waitForFinder(fab);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      final Finder name = find.byType(TextField);
      await tester.enterText(name, 'test');
      final Finder add = find.text('counters_page.dialogs.add_counter_dialog.counter_add_label'.tr());
      await tester.waitForFinder(add);
      await tester.tap(add);

      // then:
      final Finder cards = find.byType(CounterCard);
      await tester.waitForFinder(cards);
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
      final Finder fab = find.byType(FloatingActionButton);
      await tester.waitForFinder(fab);
      await tester.tap(fab);
      final Finder name = find.byType(TextField);
      await tester.waitForFinder(name);
      await tester.enterText(name, 'test');
      final Finder cancel = find.text('counters_page.dialogs.add_counter_dialog.counter_cancel_label'.tr());
      await tester.waitForFinder(cancel);
      await tester.tap(cancel);

      // then:
      final Finder cards = find.byType(CounterCard);
      await tester.waitForFinderToDisappear(cards);
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
      final Finder fab = find.byType(FloatingActionButton);
      await tester.waitForFinder(fab);
      await tester.tap(fab);
      final Finder name = find.byType(TextField);
      await tester.waitForFinder(name);
      await tester.enterText(name, 'withHistory');
      final Finder add = find.text('counters_page.dialogs.add_counter_dialog.counter_add_label'.tr());
      await tester.waitForFinder(add);
      await tester.tap(add);
      final Finder plus = find.descendant(of: find.byType(CounterCard), matching: find.byIcon(Icons.add));
      await tester.waitForFinder(plus);
      await tester.waitForFinder(plus);
      await tester.tap(plus);
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.ensureVisible(more);
      await tester.tap(more);

      // then:
      final Finder reverse = find.byIcon(Icons.undo);
      await tester.waitForFinder(reverse);
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
      final Finder fab = find.byType(FloatingActionButton);
      await tester.waitForFinder(fab);
      await tester.tap(fab);
      final Finder name = find.byType(TextField);
      await tester.waitForFinder(name);
      await tester.enterText(name, 'withHistory');
      final Finder add = find.text('counters_page.dialogs.add_counter_dialog.counter_add_label'.tr());
      await tester.waitForFinder(add);
      await tester.tap(add);
      final Finder plus = find.descendant(of: find.byType(CounterCard), matching: find.byIcon(Icons.add));
      await tester.waitForFinder(plus);
      await tester.tap(plus);
      final Finder more = find.byIcon(Icons.expand_more);
      await tester.waitForFinder(more);
      await tester.ensureVisible(more);
      await tester.tap(more);
      await tester.pumpAndSettle();
      final Finder reverse = find.byIcon(Icons.undo);
      await tester.waitForFinder(reverse);
      await tester.ensureVisible(reverse);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(reverse, warnIfMissed: false);
      await tester.pump();

      // then:
      final Finder dialog = find.byType(AlertDialog);
      await tester.waitForFinder(dialog);
      expect(dialog, findsOneWidget);
      final Finder title = find.text('counter_details_page.history.delete_title'.tr());
      expect(title, findsOneWidget);
    });
  });
}
