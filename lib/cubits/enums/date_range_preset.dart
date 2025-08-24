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
    late DateTime start;
    late DateTime end;

    switch (this) {
      case DateRangePreset.today:
        start = DateTime(now.year, now.month, now.day);
        end = now;
        break;
      case DateRangePreset.threeMonths:
        start = now.subtract(const Duration(days: 90));
        end = now;
        break;
      case DateRangePreset.sixMonths:
        start = now.subtract(const Duration(days: 180));
        end = now;
        break;
      case DateRangePreset.thisWeek:
        start = now.subtract(const Duration(days: 7));
        end = now;
        break;
      case DateRangePreset.thisMonth:
        start = now.subtract(const Duration(days: 30));
        end = now;
        break;
      case DateRangePreset.thisYear:
        start = now.subtract(const Duration(days: 365));
        end = now;
        break;
      case DateRangePreset.custom:
        start = startDate ?? now;
        end = endDate ?? now;
        break;
    }

    return DateTimeRange(start: start, end: end);
  }
}
