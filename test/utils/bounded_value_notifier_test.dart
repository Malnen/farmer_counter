import 'package:farmer_counter/utils/bounded_value_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should initialize value within bounds', () {
    // given:
    final BoundedValueNotifier notifier = BoundedValueNotifier(
      5,
      min: 0,
      max: 10,
    );

    // then:
    expect(notifier.value, 5);
  });

  test('should clamp initial value below min', () {
    // given:
    final BoundedValueNotifier notifier = BoundedValueNotifier(
      -5,
      min: 0,
      max: 10,
    );

    // then:
    expect(notifier.value, 0);
  });

  test('should clamp initial value above max', () {
    // given:
    final BoundedValueNotifier notifier = BoundedValueNotifier(
      20,
      min: 0,
      max: 10,
    );

    // then:
    expect(notifier.value, 10);
  });

  test('should clamp value when setting below min', () {
    // given:
    final BoundedValueNotifier notifier = BoundedValueNotifier(
      5,
      min: 0,
      max: 10,
    );

    // when:
    notifier.value = -3;

    // then:
    expect(notifier.value, 0);
  });

  test('should clamp value when setting above max', () {
    // given:
    final BoundedValueNotifier notifier = BoundedValueNotifier(
      5,
      min: 0,
      max: 10,
    );

    // when:
    notifier.value = 50;

    // then:
    expect(notifier.value, 10);
  });

  test('should notify listeners when value changes due to clamping', () {
    // given:
    final BoundedValueNotifier notifier = BoundedValueNotifier(
      5,
      min: 0,
      max: 10,
    );

    int callCount = 0;
    notifier.addListener(() => callCount++);

    // when:
    notifier.value = 50;

    // then:
    expect(callCount, 1);
    expect(notifier.value, 10);
  });

  test('should not notify listeners when clamped value equals current value', () {
    // given:
    final BoundedValueNotifier notifier = BoundedValueNotifier(
      10,
      min: 0,
      max: 10,
    );

    int callCount = 0;
    notifier.addListener(() => callCount++);

    // when:
    notifier.value = 100;

    // then:
    expect(callCount, 0);
  });
}
