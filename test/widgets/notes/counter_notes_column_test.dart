import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/widgets/notes/counter_notes_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_material_app.dart';

void main() {
  late List<CounterItemNote> notes;
  late Widget app;

  setUp(() {
    notes = <CounterItemNote>[
      CounterItemNote.create(
        content: 'Note 1',
        at: DateTime(2025, 8, 23, 12, 0),
        counterGuid: 'guid1',
      ),
      CounterItemNote.create(
        content: 'Note 2',
        at: DateTime(2025, 8, 23, 13, 0),
        counterGuid: 'guid2',
      ),
    ];

    app = TestMaterialApp(
      home: Scaffold(
        body: CounterNotesColumn(
          list: notes,
          onEdit: (CounterItemNote note) async {},
          onDelete: (int id) async {},
        ),
      ),
    );
  });

  testWidgets('renders all notes', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await tester.pumpAndSettle();

      // then:
      final Finder note1 = find.text('Note 1');
      expect(note1, findsOneWidget);
      final Finder note2 = find.text('Note 2');
      expect(note2, findsOneWidget);
      final Finder date1 = find.text('2025-08-23 12:00');
      expect(date1, findsOneWidget);
      final Finder date2 = find.text('2025-08-23 13:00');
      expect(date2, findsOneWidget);
    });
  });
}
