import 'package:bloc_test/bloc_test.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Map<SummaryMetric, bool> defaultMetrics = <SummaryMetric, bool>{
    for (final SummaryMetric metric in SummaryMetric.values) metric: true,
  };

  late SettingsCubit cubit;

  setUp(() {
    cubit = SettingsCubit();
  });

  tearDown(() {
    cubit.close();
  });

  blocTest<SettingsCubit, SettingsState>(
    'emits clamped tabBarScale when setTabBarScale called',
    build: SettingsCubit.new,
    act: (SettingsCubit cubit) => cubit.setTabBarScale(100),
    expect: () => <SettingsState>[
      SettingsState(
        tabBarScale: SettingsState.maxScale,
        swapPlusMinus: false,
        summaryMetricsState: defaultMetrics,
      ),
    ],
  );

  test('initial state sets all metrics enabled by default', () {
    // given:
    // when:
    // then:
    expect(
      cubit.state,
      SettingsState(
        summaryMetricsState: defaultMetrics,
      ),
    );
    expect(cubit.state.summaryMetricsState.length, SummaryMetric.values.length);
    for (final SummaryMetric metric in SummaryMetric.values) {
      final bool enabled = cubit.isSummaryMetricEnabled(metric);
      expect(enabled, isTrue);
    }
  });

  blocTest<SettingsCubit, SettingsState>(
    'emits new tabBarScale within range',
    build: SettingsCubit.new,
    act: (SettingsCubit cubit) => cubit.setTabBarScale(1.45),
    expect: () => <SettingsState>[
      SettingsState(
        tabBarScale: 1.45,
        swapPlusMinus: false,
        summaryMetricsState: defaultMetrics,
      ),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'emits new swapPlusMinus state',
    build: SettingsCubit.new,
    act: (SettingsCubit cubit) => cubit.setSwapPlusMinus(true),
    expect: () => <SettingsState>[
      SettingsState(
        tabBarScale: 1.25,
        swapPlusMinus: true,
        summaryMetricsState: defaultMetrics,
      ),
    ],
  );
  blocTest<SettingsCubit, SettingsState>(
    'setTabBarScale clamps to max',
    build: SettingsCubit.new,
    act: (SettingsCubit cubit) => cubit.setTabBarScale(100),
    expect: () => <SettingsState>[
      SettingsState(
        tabBarScale: SettingsState.maxScale,
        swapPlusMinus: false,
        summaryMetricsState: defaultMetrics,
      ),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'toggleSummaryMetric disables then enables metric',
    build: SettingsCubit.new,
    act: (SettingsCubit cubit) {
      cubit.toggleSummaryMetric(SummaryMetric.added);
      cubit.toggleSummaryMetric(SummaryMetric.added);
    },
    verify: (SettingsCubit cubit) {
      final bool enabled = cubit.isSummaryMetricEnabled(SummaryMetric.added);
      expect(enabled, isTrue);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'setSummaryMetric updates single metric',
    build: SettingsCubit.new,
    act: (SettingsCubit cubit) => cubit.setSummaryMetric(SummaryMetric.removed, false),
    verify: (SettingsCubit cubit) {
      final bool enabled = cubit.isSummaryMetricEnabled(SummaryMetric.removed);
      expect(enabled, isFalse);
      for (final SummaryMetric metric in SummaryMetric.values.where((SummaryMetric metric) => metric != SummaryMetric.removed)) {
        final bool enabled = cubit.isSummaryMetricEnabled(metric);
        expect(enabled, isTrue);
      }
    },
  );

  test('fromJson restores state and populates missing metrics', () {
    // given:
    final Map<String, Object> json = <String, Object>{
      'tabBarScale': 1.3,
      'swapPlusMinus': true,
      'summaryMetricsState': <String, bool>{
        SummaryMetric.start.name: true,
      },
    };

    // when:
    final SettingsState? restored = cubit.fromJson(json);

    // then:
    expect(restored!.tabBarScale, 1.3);
    expect(restored.swapPlusMinus, true);
    expect(restored.summaryMetricsState.length, SummaryMetric.values.length);
    for (final SummaryMetric metric in SummaryMetric.values) {
      expect(restored.summaryMetricsState[metric], isNotNull);
    }
  });

  test('toJson outputs map with all keys', () {
    // given:
    // when:
    final SettingsState state = cubit.state;
    final Map<String, Object?>? json = cubit.toJson(state);

    // then:
    expect(json, isNotNull);
    expect(json!['tabBarScale'], state.tabBarScale);
    expect(json['swapPlusMinus'], state.swapPlusMinus);
    final Map<String, Object?> metrics = json['summaryMetricsState'] as Map<String, Object?>;
    expect(metrics.keys.toSet(), SummaryMetric.values.map((SummaryMetric metric) => metric.name).toSet());
  });
}
