import 'package:farmer_counter/enums/date_range_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('today preset should return range from start of today until now', () {
    // given:
    final DateTime before = DateTime.now();

    // when:
    final DateTimeRange range = DateRangePreset.today.getPresetRange();
    final DateTime after = DateTime.now();

    // then:
    final DateTime expectedStart = DateTime(before.year, before.month, before.day);
    expect(range.start, expectedStart);
    expect(range.end.isAfter(before) || range.end.isAtSameMomentAs(before), isTrue);
    expect(range.end.isBefore(after) || range.end.isAtSameMomentAs(after), isTrue);
  });

  test('threeMonths preset should return last 90 days until now', () {
    // given:
    final DateTime now = DateTime.now();

    // when:
    final DateTimeRange range = DateRangePreset.threeMonths.getPresetRange();

    // then:
    expect(range.end.difference(now).inSeconds.abs() < 2, isTrue);
    expect(now.difference(range.start).inDays, closeTo(90, 1));
  });

  test('sixMonths preset should return last 180 days until now', () {
    // given:
    final DateTime now = DateTime.now();

    // when:
    final DateTimeRange range = DateRangePreset.sixMonths.getPresetRange();

    // then:
    expect(range.end.difference(now).inSeconds.abs() < 2, isTrue);
    expect(now.difference(range.start).inDays, closeTo(180, 1));
  });

  test('thisWeek preset should return last 7 days until now', () {
    // given:
    final DateTime now = DateTime.now();

    // when:
    final DateTimeRange range = DateRangePreset.thisWeek.getPresetRange();

    // then:
    expect(range.end.difference(now).inSeconds.abs() < 2, isTrue);
    expect(now.difference(range.start).inDays, closeTo(7, 1));
  });

  test('thisMonth preset should return last 30 days until now', () {
    // given:
    final DateTime now = DateTime.now();

    // when:
    final DateTimeRange range = DateRangePreset.thisMonth.getPresetRange();

    // then:
    expect(range.end.difference(now).inSeconds.abs() < 2, isTrue);
    expect(now.difference(range.start).inDays, closeTo(30, 1));
  });

  test('thisYear preset should return last 365 days until now', () {
    // given:
    final DateTime now = DateTime.now();

    // when:
    final DateTimeRange range = DateRangePreset.thisYear.getPresetRange();

    // then:
    expect(range.end.difference(now).inSeconds.abs() < 2, isTrue);
    expect(now.difference(range.start).inDays, closeTo(365, 1));
  });

  test('custom preset should use provided dates', () {
    // given:
    final DateTime customStart = DateTime(2020, 1, 1);
    final DateTime customEnd = DateTime(2020, 12, 31);

    // when:
    final DateTimeRange range = DateRangePreset.custom.getPresetRange(
      startDate: customStart,
      endDate: customEnd,
    );

    // then:
    expect(range.start, customStart);
    expect(range.end, customEnd);
  });
}
