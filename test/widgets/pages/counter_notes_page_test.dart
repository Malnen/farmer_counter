import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/widgets/notes/counter_note_card.dart';
import 'package:farmer_counter/widgets/pages/counter_notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';

import '../../test_material_app.dart';
import '../../tester_extension.dart';

void main() {
  late Isar isar;
  late CounterItem counterItem;
  late Widget app;

  setUp(() async {
    isar = GetIt.instance.get();
    counterItem = CounterItem.create(name: 'Test Counter');
    app = TestMaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ValueNotifier<CounterItem>>(
          create: (BuildContext context) => ValueNotifier<CounterItem>(counterItem),
          child: CounterNotesPage(),
        ),
      ),
    );
  });

  testWidgets('adds a note to Isar and shows it in UI', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder noItems = find.text('counter_notes.no_items'.tr());
      await tester.waitForFinder(noItems);
      expect(noItems, findsOneWidget);

      // when:
      final Finder fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      final Finder textField = find.byType(TextField);
      await tester.waitForFinder(textField);
      await tester.enterText(textField, 'My real note');
      final Finder add = find.text('common.add'.tr());
      await tester.tap(add);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder content = find.descendant(
        of: find.byType(CounterNoteCard),
        matching: find.text('My real note'),
      );
      await tester.waitForFinder(content);
      expect(content, findsOneWidget);
      final List<CounterItemNote> notesInDatabase = await isar.counterItemNotes.filter().counterGuidEqualTo(counterItem.guid).findAll();
      expect(notesInDatabase.length, 1);
      expect(notesInDatabase.first.content, 'My real note');
    });
  });

  testWidgets('edits a note and persists in Isar', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      final CounterItemNote note = CounterItemNote.create(counterGuid: counterItem.guid, content: 'Original');
      await isar.writeTxn(() async => isar.counterItemNotes.put(note));

      // when:
      await tester.pumpWidget(app);
      await tester.pump();
      await pumpEventQueue();

      final Finder original = find.text('Original');
      await tester.waitForFinder(original);
      await tester.tap(original);

      final Finder textField = find.byType(TextField);
      await tester.waitForFinder(textField);
      await tester.enterText(textField, 'Edited note');
      final Finder save = find.text('common.save'.tr());
      await tester.tap(save);
      await tester.pump();
      await pumpEventQueue();

      // then:
      final Finder edited = find.text('Edited note');
      await tester.waitForFinder(edited);
      expect(edited, findsOneWidget);
      final List<CounterItemNote> notesInDatabase = await isar.counterItemNotes.where().findAll();
      expect(notesInDatabase.first.content, 'Edited note');
    });
  });
}
