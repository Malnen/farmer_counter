import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/widgets/bottom_navigation_bar/scale_aware_bottom_bar.dart';
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
          child: DefaultTabController(
            length: 2,
            child: const ScaleAwareBottomBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
        ),
      ),
    );
  });

  testWidgets('renders TabBar with provided tabs and default scale', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);

      // then:
      final Finder add = find.byIcon(Icons.add);
      await tester.waitForFinder(add);
      expect(add, findsOneWidget);
      final Finder settings = find.byIcon(Icons.settings);
      expect(settings, findsOneWidget);
      final Size size = tester.getSize(find.byType(Container).first);
      expect(size.height, kBottomNavigationBarHeight * cubit.state.tabBarScale);
    });
  });

  testWidgets('updates height when scale changes', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      cubit.setTabBarScale(1.5);
      await tester.pumpAndSettle();

      // then:
      final Size size = tester.getSize(find.byType(Container).first);
      expect(size.height, kBottomNavigationBarHeight * 1.5);
    });
  });
}
