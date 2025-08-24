import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/counter_item_note.dart';
import 'package:farmer_counter/widgets/notes/counter_notes_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

class CounterNotesPage extends HookWidget {
  final int pageSize;

  const CounterNotesPage({this.pageSize = 20, super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<CounterItem> item = context.read();
    final ValueNotifier<List<CounterItemNote>> notes = useState<List<CounterItemNote>>(<CounterItemNote>[]);
    final ValueNotifier<bool> isLoading = useState(false);
    final ValueNotifier<bool> hasMore = useState(true);
    final ValueNotifier<int> offset = useState(0);
    final ScrollController scrollController = useScrollController();

    useEffect(
      () {
        _loadMore(isLoading, hasMore, item, offset, notes);
        return null;
      },
      <Object?>[item.value.guid],
    );

    useEffect(
      () {
        void onScroll() {
          if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
            _loadMore(isLoading, hasMore, item, offset, notes);
          }
        }

        scrollController.addListener(onScroll);
        return () => scrollController.removeListener(onScroll);
      },
      <Object?>[scrollController],
    );

    final List<CounterItemNote> left = <CounterItemNote>[];
    final List<CounterItemNote> right = <CounterItemNote>[];
    for (int i = 0; i < notes.value.length; i++) {
      (i.isEven ? left : right).add(notes.value[i]);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(isLoading, hasMore, item, offset, notes, context),
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (notes.value.isEmpty && isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notes.value.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('counter_notes.no_items'.tr()),
              ),
            );
          }

          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CounterNotesColumn(
                    list: left,
                    onEdit: (CounterItemNote note) => _editNote(note, context, notes),
                    onDelete: (int id) => _deleteNote(id, isLoading, hasMore, item, offset, notes),
                  ),
                ),
                Expanded(
                  child: CounterNotesColumn(
                    list: right,
                    onEdit: (CounterItemNote note) => _editNote(note, context, notes),
                    onDelete: (int id) => _deleteNote(id, isLoading, hasMore, item, offset, notes),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: hasMore.value
          ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: LinearProgressIndicator(minHeight: 3),
            )
          : null,
    );
  }

  Future<void> _reload(
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> hasMore,
    ValueNotifier<CounterItem> item,
    ValueNotifier<int> offset,
    ValueNotifier<List<CounterItemNote>> notes,
  ) async {
    notes.value = <CounterItemNote>[];
    isLoading.value = false;
    hasMore.value = true;
    offset.value = 0;
    await _loadMore(isLoading, hasMore, item, offset, notes);
  }

  Future<void> _loadMore(
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> hasMore,
    ValueNotifier<CounterItem> item,
    ValueNotifier<int> offset,
    ValueNotifier<List<CounterItemNote>> notes,
  ) async {
    if (isLoading.value || !hasMore.value) {
      return;
    }

    isLoading.value = true;
    final Isar isar = GetIt.instance.get<Isar>();
    final List<CounterItemNote> items = await isar.counterItemNotes
        .filter()
        .counterGuidEqualTo(item.value.guid)
        .sortByAtDesc()
        .offset(offset.value)
        .limit(pageSize)
        .findAll();
    if (items.length < pageSize) {
      hasMore.value = false;
    }

    notes.value = <CounterItemNote>[...notes.value, ...items];
    offset.value += items.length;
    isLoading.value = false;
  }

  Future<void> _addNote(
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> hasMore,
    ValueNotifier<CounterItem> item,
    ValueNotifier<int> offset,
    ValueNotifier<List<CounterItemNote>> notes,
    BuildContext context,
  ) async {
    final String? content = await _showNoteDialog(context, initial: '');
    if (content == null || content.trim().isEmpty) {
      return;
    }

    final Isar isar = GetIt.instance.get<Isar>();
    final CounterItemNote created = CounterItemNote.create(
      counterGuid: item.value.guid,
      content: content.trim(),
    );
    await isar.writeTxn(() async => isar.counterItemNotes.put(created));
    await _reload(isLoading, hasMore, item, offset, notes);
  }

  Future<void> _editNote(
    CounterItemNote note,
    BuildContext context,
    ValueNotifier<List<CounterItemNote>> notes,
  ) async {
    final String? content = await _showNoteDialog(context, initial: note.content);
    if (content == null) {
      return;
    }

    final String trimmed = content.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final Isar isar = GetIt.instance.get<Isar>();
    await isar.writeTxn(() async {
      final CounterItemNote? fresh = await isar.counterItemNotes.get(note.id);
      if (fresh == null) {
        return;
      }

      final CounterItemNote updated = CounterItemNote(
        id: fresh.id,
        counterGuid: fresh.counterGuid,
        at: fresh.at,
        content: trimmed,
      );
      await isar.counterItemNotes.put(updated);
    });
    final int idx = notes.value.indexWhere((CounterItemNote e) => e.id == note.id);
    if (idx != -1) {
      final List<CounterItemNote> copy = List<CounterItemNote>.from(notes.value);
      copy[idx] = CounterItemNote(
        id: note.id,
        counterGuid: note.counterGuid,
        at: note.at,
        content: trimmed,
      );
      notes.value = copy;
    }
  }

  Future<void> _deleteNote(
    int id,
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> hasMore,
    ValueNotifier<CounterItem> item,
    ValueNotifier<int> offset,
    ValueNotifier<List<CounterItemNote>> notes,
  ) async {
    final Isar isar = GetIt.instance.get<Isar>();
    await isar.writeTxn(() async {
      await isar.counterItemNotes.delete(id);
    });
    notes.value = notes.value.where((CounterItemNote note) => note.id != id).toList(growable: false);
    if (notes.value.length < pageSize && hasMore.value) {
      await _loadMore(isLoading, hasMore, item, offset, notes);
    }
  }

  Future<String?> _showNoteDialog(BuildContext context, {required String initial}) async {
    final TextEditingController controller = TextEditingController(text: initial);
    final String title = initial.isEmpty ? 'counter_notes.add.title'.tr() : 'counter_notes.edit.title'.tr();
    final String action = initial.isEmpty ? 'common.add'.tr() : 'common.save'.tr();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(hintText: 'counter_notes.hint'.tr()),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('common.cancel'.tr())),
          TextButton(onPressed: () => Navigator.of(context).pop(controller.text), child: Text(action)),
        ],
      ),
    );
  }
}
