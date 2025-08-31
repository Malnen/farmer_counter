class CounterSummary {
  final int startValue;
  final int endValue;
  final int addedCount;
  final int removedCount;
  final int difference;
  final num percentChange;
  final num averagePerDay;
  final num averagePerDayAdded;
  final num averagePerDayRemoved;
  final int? maxValue;
  final int? minValue;

  CounterSummary({
    required this.startValue,
    required this.endValue,
    required this.addedCount,
    required this.removedCount,
    required this.difference,
    required this.percentChange,
    required this.averagePerDay,
    required this.averagePerDayAdded,
    required this.averagePerDayRemoved,
    this.maxValue,
    this.minValue,
  });
}
