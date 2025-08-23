import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';

part '../generated/models/counter_change_item.freezed.dart';
part '../generated/models/counter_change_item.g.dart';

@Collection(ignore: <String>{'copyWith'})
@freezed
@JsonSerializable()
class CounterChangeItem with _$CounterChangeItem {
  @override
  final Id id;
  @override
  @Index(composite: <CompositeIndex>[CompositeIndex('at')])
  final String counterGuid;
  @override
  @Index()
  final DateTime at;
  @override
  final int delta;
  @override
  final int newValue;

  const CounterChangeItem({
    required this.id,
    required this.counterGuid,
    required this.at,
    required this.delta,
    required this.newValue,
  });

  factory CounterChangeItem.create({
    required String counterGuid,
    required int delta,
    required int newValue,
    DateTime? at,
  }) =>
      CounterChangeItem(
        id: Isar.autoIncrement,
        counterGuid: counterGuid,
        at: at ?? DateTime.now(),
        delta: delta,
        newValue: newValue,
      );

  factory CounterChangeItem.fromJson(Map<String, Object?> json) => _$CounterChangeItemFromJson(json);

  Map<String, Object?> toJson() => _$CounterChangeItemToJson(this);
}
