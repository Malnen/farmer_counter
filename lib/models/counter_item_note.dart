import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';

part '../generated/models/counter_item_note.freezed.dart';

part '../generated/models/counter_item_note.g.dart';

@Collection(ignore: <String>{'copyWith'})
@freezed
@JsonSerializable()
class CounterItemNote with _$CounterItemNote {
  @override
  final Id id;
  @override
  @Index(composite: <CompositeIndex>[CompositeIndex('at')])
  final String counterGuid;
  @override
  @Index()
  final DateTime at;
  @override
  final String content;

  const CounterItemNote({
    required this.id,
    required this.counterGuid,
    required this.at,
    required this.content,
  });

  factory CounterItemNote.create({
    required String counterGuid,
    required String content,
    DateTime? at,
  }) =>
      CounterItemNote(
        id: Isar.autoIncrement,
        counterGuid: counterGuid,
        at: at ?? DateTime.now(),
        content: content,
      );

  factory CounterItemNote.fromJson(Map<String, Object?> json) => _$CounterItemNoteFromJson(json);

  Map<String, Object?> toJson() => _$CounterItemNoteToJson(this);
}
