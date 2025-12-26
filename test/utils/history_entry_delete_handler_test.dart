import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/utils/history_entry_delete_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/single_child_widget.dart';

import '../test_material_app.dart';
import '../tester_extension.dart';
import '../when_extension.dart';

class _MockCounterCubit extends Mock implements CounterCubit {}

void main() {
  late Widget app;
  late _MockCounterCubit cubit;

  setUp(() {
    cubit = _MockCounterCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream<CounterState>.empty());
    when(() => cubit.state).thenReturn(const CounterState(items: <CounterItem>[]));
    when(() => cubit.deleteHistoryEntry(any(), any())).thenDoNothing();
    app = TestMaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<CounterCubit>.value(value: cubit),
          ],
          child: Builder(
            builder: (BuildContext context) => ElevatedButton(
              onPressed: () => HistoryEntryDeleteHandler.show(
                context,
                guid: 'guid-123',
                changeId: 42,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
  });

  testWidgets('should show dialog with correct title and message', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // when:
      final Finder open = find.text('open');
      await tester.waitForFinder(open);
      await tester.tap(open);

      // then:
      final Finder dialog = find.byType(AlertDialog);
      await tester.waitForFinder(dialog);
      expect(dialog, findsOneWidget);
      final Finder title = find.text('counter_details_page.history.delete_title'.tr());
      expect(title, findsOneWidget);
      final Finder message = find.text('counter_details_page.history.delete_message'.tr());
      expect(message, findsOneWidget);
    });
  });

  testWidgets('should not call deleteHistoryEntry when cancel pressed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder open = find.text('open');
      await tester.waitForFinder(open);
      await tester.tap(open);

      // when:
      final Finder cancel = find.text('common.cancel'.tr());
      await tester.waitForFinder(cancel);
      await tester.tap(cancel);
      await tester.pumpAndSettle();

      // then:
      verifyNever(() => cubit.deleteHistoryEntry(any(), any()));
    });
  });

  testWidgets('should call deleteHistoryEntry when confirm pressed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      final Finder open = find.text('open');
      await tester.waitForFinder(open);
      await tester.tap(open);

      // when:
      final Finder confirm = find.text('counter_details_page.history.delete_cta'.tr());
      await tester.waitForFinder(confirm);
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      // then:
      verify(() => cubit.deleteHistoryEntry('guid-123', 42)).called(1);
    });
  });
}
