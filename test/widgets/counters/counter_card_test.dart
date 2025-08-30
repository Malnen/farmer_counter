import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/widgets/counters/counter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_mocks.dart';

void main() {
  late Widget app;
  late MockFunction onMinus;
  late MockFunction onPlus;
  late SettingsCubit settingsCubit;

  setUp(() {
    onMinus = MockFunction();
    onPlus = MockFunction();
    settingsCubit = SettingsCubit();
    app = MaterialApp(
      home: Scaffold(
        body: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: CounterCard(
            name: 'name',
            count: 5,
            onMinus: onMinus.call,
            onPlus: onPlus.call,
          ),
        ),
      ),
    );
  });

  testWidgets('should render', (WidgetTester tester) async {
    // given:
    // when:
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // then:
    final Finder card = find.byType(CounterCard);
    expect(card, findsOneWidget);
    final Finder name = find.text('name');
    expect(name, findsOneWidget);
    final Finder count = find.text('5');
    expect(count, findsOneWidget);
  });

  testWidgets('should call callbacks', (WidgetTester tester) async {
    // given:
    // when:
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    final Finder minus = find.byIcon(Icons.remove);
    await tester.tap(minus);
    final Finder add = find.byIcon(Icons.add);
    await tester.tap(add);

    // then:
    verifyInOrder(<VoidCallback>[
      onMinus.call,
      onPlus.call,
    ]);
  });

  testWidgets('should render minus then plus by default', (WidgetTester tester) async {
    // given:
    // when:
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // then:
    final List<IconData?> icons = tester.widgetList<Icon>(find.byType(Icon)).map((Icon icon) => icon.icon).toList();
    expect(
      icons,
      containsAllInOrder(
        <IconData>[
          Icons.remove,
          Icons.add,
        ],
      ),
    );
  });

  testWidgets('should render plus then minus when swapped', (WidgetTester tester) async {
    // given:
    settingsCubit.setSwapPlusMinus(true);

    // when:
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    // then:
    final List<IconData?> icons = tester.widgetList<Icon>(find.byType(Icon)).map((Icon i) => i.icon).toList();
    expect(
      icons,
      containsAllInOrder(
        <IconData>[
          Icons.add,
          Icons.remove,
        ],
      ),
    );
  });
}
