import 'package:farmer_counter/cubits/enums/date_range_preset.dart';
import 'package:flutter/material.dart';

class DateRangeSelection {
  final DateRangePreset preset;
  final DateTime startDate;
  final DateTime endDate;

  DateRangeSelection({
    required this.preset,
    required this.startDate,
    required this.endDate,
  });

  factory DateRangeSelection.fromPreset(
    DateRangePreset preset, {
    DateTime? customStart,
    DateTime? customEnd,
  }) {
    final DateTimeRange range = preset.getPresetRange(startDate: customStart, endDate: customEnd);
    return DateRangeSelection(
      preset: preset,
      startDate: range.start,
      endDate: range.end,
    );
  }

  DateTimeRange toRange() => DateTimeRange(start: startDate, end: endDate);
}
