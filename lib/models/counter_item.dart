import 'package:farmer_counter/enums/counter_chart_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

part '../generated/models/counter_item.freezed.dart';

part '../generated/models/counter_item.g.dart';

@Collection(ignore: <String>{'copyWith'})
@freezed
@JsonSerializable()
class CounterItem with _$CounterItem {
  @override
  @Index(unique: true)
  final String guid;
  @override
  final String name;
  @override
  final int count;
  @override
  final DateTime createdAt;
  @override
  final Id id;
  @override
  @enumerated
  final CounterChartType lastSelectedChartType;

  const CounterItem({
    required this.guid,
    required this.name,
    required this.count,
    required this.createdAt,
    required this.id,
    this.lastSelectedChartType = CounterChartType.bar,
  });

  factory CounterItem.create({
    required String name,
    int count = 0,
    DateTime? createdAt,
  }) =>
      CounterItem(
        guid: const Uuid().v4(),
        name: name,
        count: count,
        createdAt: createdAt ?? DateTime.now(),
        id: Isar.autoIncrement,
      );

  factory CounterItem.fromJson(Map<String, Object?> json) => _$CounterItemFromJson(json);

  Map<String, Object?> toJson() => _$CounterItemToJson(this);
}
