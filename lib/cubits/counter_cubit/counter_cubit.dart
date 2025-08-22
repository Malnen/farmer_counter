import 'package:farmer_counter/cubits/counter_cubit/couter_state.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(items: <CounterItem>[]));

  void addItem(String name) {
    name = name.trim();
    if (name.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        items: <CounterItem>[
          ...state.items,
          CounterItem.create(name: name),
        ],
      ),
    );
  }

  void removeItem(String guid) {
    emit(
      state.copyWith(
        items: state.items.where((CounterItem item) => item.guid != guid).toList(),
      ),
    );
  }

  void increment(String guid) {
    emit(
      state.copyWith(
        items: state.items
            .map(
              (CounterItem item) => item.guid == guid ? item.copyWith(count: item.count + 1) : item,
            )
            .toList(),
      ),
    );
  }

  void decrement(String guid) {
    emit(
      state.copyWith(
        items: state.items
            .map((CounterItem item) => item.guid == guid ? item.copyWith(count: item.count > 0 ? item.count - 1 : 0) : item)
            .toList(),
      ),
    );
  }
}
