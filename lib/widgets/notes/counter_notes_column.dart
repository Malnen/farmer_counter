import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/widgets/notes/counter_note_card.dart';
import 'package:flutter/material.dart';

class CounterNotesColumn extends StatelessWidget {
  final List<CounterItemNote> list;
  final Future<void> Function(CounterItemNote) onEdit;
  final Future<void> Function(int) onDelete;

  const CounterNotesColumn({
    required this.list,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(list.length, (int index) {
        final CounterItemNote note = list[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == list.length - 1 ? 0 : 12),
          child: CounterNoteCard(
            note: note,
            onEdit: () => onEdit(note),
            onDelete: () => onDelete(note.id),
          ),
        );
      }),
    );
  }
}
