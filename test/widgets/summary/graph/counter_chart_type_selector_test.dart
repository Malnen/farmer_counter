import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/enums/counter_chart_type.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/summary/graph/counter_chart_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common_bloc_mocks.dart';
import '../../../test_material_app.dart';
import '../../../tester_extension.dart';

void main() {
  late CounterCubit cubit;
  late CounterItem item;
  late Widget app;

  setUp(() {
    registerFallbackValue(CounterItem.create(name: 'name'));
    cubit = MockCounterItemCubit();
    when(() => cubit.state).thenReturn(
      const CounterState(items: <CounterItem>[]),
    );
    when(() => cubit.stream).thenAnswer(
      (_) => const Stream<CounterState>.empty(),
    );
    item = CounterItem.create(name: 'Test');
    app = TestMaterialApp(
      home: Scaffold(
        body: BlocProvider<CounterCubit>.value(
          value: cubit,
          child: CounterChartTypeSelector(
            item: item,
          ),
        ),
      ),
    );
  });

  testWidgets('should render segmented button', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);

      // then:
      final Finder segmented = find.byType(SegmentedButton<CounterChartType>);
      await tester.waitForFinder(segmented);
      expect(segmented, findsOneWidget);
    });
  });

  testWidgets('should select bar chart initially', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);

      // then:
      final Finder buttonFinder = find.byType(SegmentedButton<CounterChartType>);
      await tester.waitForFinder(buttonFinder);
      final SegmentedButton<CounterChartType> button = tester.widget(buttonFinder);
      expect(
        button.selected,
        <CounterChartType>{CounterChartType.bar},
      );
    });
  });

  testWidgets('should call cubit when chart type changes', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      when(() => cubit.updateItem(any())).thenAnswer((_) async {});
      await tester.pumpWidget(app);

      // when:
      final Finder lineIcon = find.byIcon(Icons.show_chart);
      await tester.waitForFinder(lineIcon);
      expect(lineIcon, findsOneWidget);
      await tester.tap(lineIcon);
      await tester.pumpAndSettle();

      // then:
      verify(
        () => cubit.updateItem(
          any(
            that: isA<CounterItem>().having(
              (CounterItem i) => i.lastSelectedChartType,
              'lastSelectedChartType',
              CounterChartType.line,
            ),
          ),
        ),
      ).called(1);
    });
  });

  testWidgets('should not call cubit when selecting same chart type', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      when(() => cubit.updateItem(any())).thenAnswer((_) async {});
      await tester.pumpWidget(app);

      // when:
      final Finder barIcon = find.byIcon(Icons.bar_chart);
      await tester.waitForFinder(barIcon);
      await tester.tap(barIcon);
      await tester.pumpAndSettle();

      // then:
      verifyNever(() => cubit.updateItem(any()));
    });
  });
}
