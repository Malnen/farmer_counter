import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part '../generated/models/counter_item.freezed.dart';

@freezed
class CounterItem with _$CounterItem {
  @override
  final String guid;
  @override
  final String name;
  @override
  final int count;
  @override
  final DateTime createdAt;

  const CounterItem({
    required this.guid,
    required this.name,
    required this.count,
    required this.createdAt,
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
      );
}
