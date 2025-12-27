import 'package:flutter/foundation.dart';

class BoundedValueNotifier extends ValueNotifier<double> {
  final double min;
  final double max;

  BoundedValueNotifier(
    double value, {
    required this.min,
    required this.max,
  }) : super(value.clamp(min, max));

  @override
  set value(double newValue) {
    super.value = newValue.clamp(min, max);
  }
}
