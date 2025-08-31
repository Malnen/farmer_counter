import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(_initialState());

  static SettingsState _initialState() {
    final SettingsState base = const SettingsState();
    return _withDefaults(base);
  }

  static SettingsState _withDefaults(SettingsState state) {
    final Map<SummaryMetric, bool> patched = <SummaryMetric, bool>{
      for (final SummaryMetric metric in SummaryMetric.values) metric: state.summaryMetricsState[metric] ?? true,
    };

    return state.copyWith(summaryMetricsState: patched);
  }

  void setTabBarScale(double scale) {
    final double clamped = scale.clamp(SettingsState.minScale, SettingsState.maxScale);
    emit(state.copyWith(tabBarScale: clamped));
  }

  void setSwapPlusMinus(bool value) => emit(state.copyWith(swapPlusMinus: value));

  void toggleSummaryMetric(SummaryMetric metric) {
    final bool current = state.summaryMetricsState[metric] ?? true;
    setSummaryMetric(metric, !current);
  }

  void setSummaryMetric(SummaryMetric metric, bool enabled) {
    final Map<SummaryMetric, bool> newMap = Map<SummaryMetric, bool>.from(state.summaryMetricsState);
    newMap[metric] = enabled;
    for (final SummaryMetric metric in SummaryMetric.values) {
      newMap[metric] = newMap[metric] ?? true;
    }

    emit(state.copyWith(summaryMetricsState: newMap));
  }

  bool isSummaryMetricEnabled(SummaryMetric metric) => state.summaryMetricsState[metric] ?? true;

  @override
  SettingsState? fromJson(Map<String, Object?> json) {
    final SettingsState restored = SettingsState.fromJson(json);
    return _withDefaults(restored);
  }

  @override
  Map<String, Object?>? toJson(SettingsState state) => state.toJson();
}
