import 'package:farmer_counter/models/counter_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/cubits/counter_cubit/couter_state.freezed.dart';

@freezed
class CounterState with _$CounterState {
  @override
  final List<CounterItem> items;

  const CounterState({required this.items});
}
