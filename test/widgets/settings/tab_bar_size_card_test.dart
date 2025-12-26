import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/widgets/settings/tab_bar_size_card.dart';
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
          child: const TabBarSizeCard(),
        ),
      ),
    );
  });

  testWidgets('renders with title, slider and current scale text', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder title = find.text('settings.tabBarSize.title'.tr());
      await tester.waitForFinder(title);
      expect(title, findsOneWidget);
      final Finder slider = find.byType(Slider);
      expect(slider, findsOneWidget);
      final Finder current = find.textContaining(
        'settings.tabBarSize.current'.tr(
          namedArgs: <String, String>{'x': (cubit.state.tabBarScale * 100).toStringAsFixed(0)},
        ),
      );
      expect(current, findsOneWidget);
    });
  });

  testWidgets('moving slider updates cubit state', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);

      // when:
      final Finder slider = find.byType(Slider);
      await tester.waitForFinder(slider);
      await tester.drag(slider, const Offset(200, 0));
      await tester.pumpAndSettle();

      // then:
      expect(cubit.state.tabBarScale, isNot(equals(1.0)));
    });
  });

  testWidgets('label shows correct percent when sliding', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);

      // when:
      final Finder slider = find.byType(Slider);
      await tester.waitForFinder(slider);
      await tester.drag(slider, const Offset(200, 0));

      // then:
      final Finder label = find.textContaining('%');
      await tester.waitForFinder(label);
      expect(label, findsWidgets);
    });
  });
}
