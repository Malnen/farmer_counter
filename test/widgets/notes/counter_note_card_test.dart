import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/widgets/notes/counter_note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_mocks.dart';
import '../../test_material_app.dart';

void main() {
  late Widget app;
  late MockFunction onEdit;
  late MockFunction onDelete;
  late CounterItemNote note;

  setUp(() {
    onEdit = MockFunction();
    onDelete = MockFunction();
    note = CounterItemNote.create(content: 'Test note', at: DateTime(2025, 8, 23, 15, 30), counterGuid: 'guid');
    app = TestMaterialApp(
      home: Scaffold(
        body: CounterNoteCard(
          note: note,
          onEdit: onEdit.call,
          onDelete: onDelete.call,
        ),
      ),
    );
  });

  testWidgets('renders content and date', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder noteText = find.text('Test note');
      expect(noteText, findsOneWidget);
      final Finder date = find.text('2025-08-23 15:30');
      expect(date, findsOneWidget);
      final Finder menu = find.byType(PopupMenuButton<int>);
      expect(menu, findsOneWidget);
    });
  });

  testWidgets('tapping card calls onEdit', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();

      // then:
      final Finder card = find.byType(Card);
      await tester.tap(card);
      verify(onEdit.call).called(1);
    });
  });

  testWidgets('selecting "Edit" from popup calls onEdit', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder menu = find.byType(PopupMenuButton<int>);
      await tester.tap(menu);
      await tester.pumpAndSettle();
      final Finder edit = find.text('common.edit'.tr());
      await tester.tap(edit);
      await tester.pumpAndSettle();

      // then:
      verify(onEdit.call).called(1);
    });
  });

  testWidgets('selecting "Delete" from popup shows dialog and calls onDelete', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder menu = find.byType(PopupMenuButton<int>);
      await tester.tap(menu);
      await tester.pumpAndSettle();
      final Finder delete = find.text('common.delete'.tr());
      await tester.tap(delete);
      await tester.pumpAndSettle();
      final Finder dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      final Finder deleteButton = find.widgetWithText(TextButton, 'common.delete'.tr());
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // then:
      verify(onDelete.call).called(1);
    });
  });

  testWidgets('selecting "Delete" and canceling does not call onDelete', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();
      await tester.pumpAndSettle();
      final Finder menu = find.byType(PopupMenuButton<int>);
      await tester.tap(menu);
      await tester.pumpAndSettle();
      final Finder delete = find.text('common.delete'.tr());
      await tester.tap(delete);
      await tester.pumpAndSettle();
      final Finder cancelButton = find.widgetWithText(TextButton, 'common.cancel'.tr());
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // then:
      verifyNever(onDelete.call);
    });
  });
}
