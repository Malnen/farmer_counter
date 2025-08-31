import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:farmer_counter/extensions/summary_metric_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('icon mapping is correct', () {
    expect(SummaryMetric.start.icon, Icons.first_page);
    expect(SummaryMetric.end.icon, Icons.last_page);
    expect(SummaryMetric.added.icon, Icons.add);
    expect(SummaryMetric.removed.icon, Icons.remove);
    expect(SummaryMetric.difference.icon, Icons.swap_vert);
    expect(SummaryMetric.percentChange.icon, Icons.percent);
    expect(SummaryMetric.averagePerDay.icon, Icons.calendar_today);
    expect(SummaryMetric.averagePerDayAdded.icon, Icons.trending_up);
    expect(SummaryMetric.averagePerDayRemoved.icon, Icons.trending_down);
    expect(SummaryMetric.maxValue.icon, Icons.arrow_circle_up);
    expect(SummaryMetric.minValue.icon, Icons.arrow_circle_down);
  });

  test('label keys are generated correctly', () {
    for (final SummaryMetric metric in SummaryMetric.values) {
      expect(metric.label, contains('counter_summary_card.${metric.name}'));
    }
  });

  test('description keys are generated correctly', () {
    for (final SummaryMetric metric in SummaryMetric.values) {
      expect(
        metric.description,
        contains('settings.summary_metrics.descriptions.${metric.name}'),
      );
    }
  });
}
