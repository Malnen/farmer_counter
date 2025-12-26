import 'package:flutter/material.dart';

enum DateRangePreset {
  today,
  threeMonths,
  sixMonths,
  thisWeek,
  thisMonth,
  thisYear,
  custom,
}

extension DateRangePresetExtension on DateRangePreset {
  DateTimeRange getPresetRange({DateTime? startDate, DateTime? endDate}) {
    final DateTime now = DateTime.now();
    final DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    late DateTime start;
    late DateTime end;

    switch (this) {
      case DateRangePreset.today:
        start = DateTime(now.year, now.month, now.day);
        end = endOfToday;
        break;
      case DateRangePreset.threeMonths:
        start = now.subtract(const Duration(days: 90));
        end = endOfToday;
        break;
      case DateRangePreset.sixMonths:
        start = now.subtract(const Duration(days: 180));
        end = endOfToday;
        break;
      case DateRangePreset.thisWeek:
        start = now.subtract(const Duration(days: 7));
        end = endOfToday;
        break;
      case DateRangePreset.thisMonth:
        start = now.subtract(const Duration(days: 30));
        end = endOfToday;
        break;
      case DateRangePreset.thisYear:
        start = now.subtract(const Duration(days: 365));
        end = endOfToday;
        break;
      case DateRangePreset.custom:
        start = startDate ?? now;
        end = endDate ?? endOfToday;
        break;
    }

    return DateTimeRange(start: start, end: end);
  }
}
