import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/pages/counter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/single_child_widget.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late Widget app;
  late CounterItem item;

  CounterItem? deletedItem;

  setUp(() {
    deletedItem = null;
    item = CounterItem.create(name: 'TestCounter');
    app = TestMaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<CounterCubit>(create: (BuildContext context) => CounterCubit()),
            BlocProvider<SettingsCubit>(create: (BuildContext context) => SettingsCubit()),
          ],
          child: CounterPage(
            item: item,
            onDelete: (CounterItem item) => deletedItem = item,
          ),
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
      final Finder counterPage = find.byType(CounterPage);
      await tester.waitForFinder(counterPage);
      expect(counterPage, findsOneWidget);
      final Finder appbarTitle = find.descendant(of: find.byType(AppBar), matching: find.text(item.name));
      expect(appbarTitle, findsOneWidget);
    });
  });

  testWidgets('should delete item after confirm', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder deleteIcon = find.byIcon(Icons.delete);
      await tester.waitForFinder(deleteIcon);
      await tester.tap(deleteIcon);
      final Finder delete = find.text('counter_details_page.dialogs.delete_counter.delete'.tr());
      await tester.waitForFinder(delete);
      await tester.tap(delete);
      await tester.pumpAndSettle();

      // then:
      expect(deletedItem, isNotNull);
      expect(deletedItem!.guid, item.guid);
    });
  });

  testWidgets('should not delete item on cancel', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder deleteIcon = find.byIcon(Icons.delete);
      await tester.waitForFinder(deleteIcon);
      await tester.tap(deleteIcon);
      final Finder cancel = find.text('counter_details_page.dialogs.delete_counter.cancel'.tr());
      await tester.waitForFinder(cancel);
      await tester.tap(cancel);
      await tester.pumpAndSettle();

      // then:
      expect(deletedItem, isNull);
    });
  });
}
