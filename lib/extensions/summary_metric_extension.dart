import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:flutter/material.dart';

extension SummaryMetricExtension on SummaryMetric {
  String get label => 'counter_summary_card.$name'.tr();

  String get description => 'settings.summary_metrics.descriptions.$name'.tr();

  IconData get icon => switch (this) {
        SummaryMetric.start => Icons.first_page,
        SummaryMetric.end => Icons.last_page,
        SummaryMetric.added => Icons.add,
        SummaryMetric.removed => Icons.remove,
        SummaryMetric.difference => Icons.swap_vert,
        SummaryMetric.percentChange => Icons.percent,
        SummaryMetric.averagePerDay => Icons.calendar_today,
        SummaryMetric.averagePerDayAdded => Icons.trending_up,
        SummaryMetric.averagePerDayRemoved => Icons.trending_down,
        SummaryMetric.maxValue => Icons.arrow_circle_up,
        SummaryMetric.minValue => Icons.arrow_circle_down,
      };
}
