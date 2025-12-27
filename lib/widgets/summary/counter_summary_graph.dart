import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_change_item.dart';
import 'package:farmer_counter/models/counter_chart_data.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/models/date_range_selection.dart';
import 'package:farmer_counter/utils/bounded_value_notifier.dart';
import 'package:farmer_counter/widgets/scale_listener/scale_listener.dart';
import 'package:farmer_counter/widgets/summary/graph/chart_zoom_slider.dart';
import 'package:farmer_counter/widgets/summary/graph/counter_chart_type_selector.dart';
import 'package:farmer_counter/widgets/summary/graph/counter_graph_builder.dart';
import 'package:farmer_counter/widgets/summary/graph/counter_graph_factory.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

class CounterSummaryGraph extends StatefulHookWidget {
  final DateRangeSelection selection;

  const CounterSummaryGraph({
    required this.selection,
  });

  @override
  State<CounterSummaryGraph> createState() => CounterSummaryGraphState();
}

class CounterSummaryGraphState extends State<CounterSummaryGraph> {
  static const double leftSideSize = 32;
  static const double barWidth = 28;
  static const int minVisibleBars = 10;
  static const double chartTopPadding = 8;
  static const double chartBottomPadding = 24;

  late Isar isar;
  late ValueNotifier<CounterItem> item;
  late ValueNotifier<bool> isLoading;
  late ValueNotifier<List<CounterChangeItem>> changeItems;
  late ValueNotifier<double> minY;
  late ValueNotifier<double> maxY;
  late ValueNotifier<double> maxScale;

  @override
  void initState() {
    super.initState();
    isar = GetIt.instance.get<Isar>();
  }

  @override
  Widget build(BuildContext context) {
    item = context.watch();
    isLoading = useState<bool>(true);
    changeItems = useState<List<CounterChangeItem>>(<CounterChangeItem>[]);
    minY = useState<double>(0);
    maxY = useState<double>(0);
    maxScale = useState<double>(1);

    final ValueNotifier<double> scale = useMemoized(
      () => BoundedValueNotifier(1, min: 1, max: maxScale.value),
      <Object?>[maxScale.value],
    );
    useValueListenable(scale);
    final ScrollController scrollController = useScrollController();

    useEffect(
      () {
        loadData(context);
        scale.value = 1;
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }

        return null;
      },
      <Object?>[widget.selection],
    );

    return SizedBox(
      height: 260,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CounterChartTypeSelector(item: item.value),
                  ChartZoomSlider(
                    scale: scale,
                    minScale: 1,
                    maxScale: maxScale.value,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (BuildContext context, bool loading, _) {
                    if (loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (changeItems.value.isEmpty) {
                      return Center(
                        child: Text('counter_summary_graph.no_data'.tr()),
                      );
                    }

                    final CounterChartData chartData = CounterChartData(
                      items: changeItems.value,
                      minY: minY.value,
                      maxY: maxY.value,
                    );
                    final CounterItemChartBuilder builder = CounterItemChartFactory.create(item.value.lastSelectedChartType);

                    return LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final double viewportWidth = constraints.maxWidth - leftSideSize;
                        final double baseWidth = max(
                          viewportWidth,
                          changeItems.value.length * barWidth,
                        );
                        WidgetsBinding.instance.addPostFrameCallback(
                          (Duration timeStamp) => maxScale.value = max(1, baseWidth / (minVisibleBars * barWidth)),
                        );
                        final double chartWidth = max(viewportWidth, viewportWidth * scale.value);
                        final double chartHeight = constraints.maxHeight - chartTopPadding;

                        return Padding(
                          padding: const EdgeInsets.only(
                            top: chartTopPadding,
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: leftSideSize,
                                height: chartHeight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: chartBottomPadding,
                                  ),
                                  child: BarChart(
                                    BarChartData(
                                      minY: minY.value,
                                      maxY: maxY.value,
                                      barTouchData: BarTouchData(enabled: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: leftSideSize,
                                            getTitlesWidget: (double value, _) => Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                textAlign: TextAlign.end,
                                                value.toInt().toString(),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      gridData: FlGridData(show: true),
                                      barGroups: const <BarChartGroupData>[],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ScaleListener(
                                  behavior: HitTestBehavior.translucent,
                                  onScaleUpdate: (double delta) {
                                    if (delta > 0 && delta.isFinite && delta != 1) {
                                      scale.value = (scale.value * delta).clamp(1, maxScale.value).toDouble();
                                    }
                                  },
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: builder.build(
                                      context: context,
                                      data: chartData,
                                      width: chartWidth,
                                      height: chartHeight,
                                      showLeftTitles: false,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData(BuildContext context) async {
    isLoading.value = true;
    final DateTimeRange range = widget.selection.toRange();
    final List<CounterChangeItem> results =
        await isar.counterChangeItems.filter().counterGuidEqualTo(item.value.guid).and().atBetween(range.start, range.end).findAll();
    double localMin = 0;
    double localMax = 0;
    for (final CounterChangeItem item in results) {
      final double y = item.delta.toDouble();
      if (y < localMin) {
        localMin = y;
      }

      if (y > localMax) {
        localMax = y;
      }
    }

    if (context.mounted) {
      results.sort((CounterChangeItem a, CounterChangeItem b) => a.at.compareTo(b.at));
      changeItems.value = results;
      isLoading.value = false;
      minY.value = localMin;
      maxY.value = localMax;
    }
  }
}
