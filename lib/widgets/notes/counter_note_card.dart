import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:flutter/material.dart';

class CounterNoteCard extends StatelessWidget {
  final CounterItemNote note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CounterNoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                note.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(note.at),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  PopupMenuButton<int>(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(value: 0, child: Text('common.edit'.tr())),
                      PopupMenuItem<int>(value: 1, child: Text('common.delete'.tr())),
                    ],
                    onSelected: (int value) async {
                      if (value == 0) {
                        onEdit();
                      } else if (value == 1) {
                        await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('counter_notes.delete.title'.tr()),
                            content: Text('counter_notes.delete.message'.tr()),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('common.cancel'.tr()),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  onDelete();
                                },
                                child: Text('common.delete'.tr()),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
