import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/widgets/settings/plus_minus_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late SettingsCubit cubit;
  late Widget app;

  setUp(() {
    cubit = SettingsCubit();
    app = TestMaterialApp(
      home: Scaffold(
        body: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const PlusMinusOrderCard(),
        ),
      ),
    );
  });

  testWidgets('renders with title and switch', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder title = find.text('settings.plusMinusOrder.title'.tr());
      await tester.waitForFinder(title);
      expect(title, findsOneWidget);
      final Finder switchTile = find.byType(SwitchListTile);
      expect(switchTile, findsOneWidget);
    });
  });

  testWidgets('toggles switch to true updates cubit state', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);

      // when:
      final Finder switchFinder = find.byType(Switch);
      await tester.waitForFinder(switchFinder);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // then:
      expect(cubit.state.swapPlusMinus, isTrue);
    });
  });

  testWidgets('toggles switch back to false updates cubit state', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      cubit.setSwapPlusMinus(true);
      await tester.pumpWidget(app);

      // when:
      final Finder switchFinder = find.byType(Switch);
      await tester.waitForFinder(switchFinder);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // then:
      expect(cubit.state.swapPlusMinus, isFalse);
    });
  });
}
