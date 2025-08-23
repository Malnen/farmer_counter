import 'package:farmer_counter/models/counter_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/cubits/counter_cubit/couter_state.freezed.dart';

enum CounterStatus { initial, loaded }

@freezed
class CounterState with _$CounterState {
  @override
  final List<CounterItem> items;
  @override
  final CounterStatus status;

  const CounterState({
    required this.items,
    this.status = CounterStatus.initial,
  });
}
