// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, always_specify_types, unused_element, unnecessary_non_null_assertion

part of '../../../cubits/settings/settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    SettingsState(
      tabBarScale: (json['tabBarScale'] as num?)?.toDouble() ?? 1.25,
      swapPlusMinus: json['swapPlusMinus'] as bool? ?? false,
      summaryMetricsState:
          (json['summaryMetricsState'] as Map<String, dynamic>?)?.map(
                (k, e) =>
                    MapEntry($enumDecode(_$SummaryMetricEnumMap, k), e as bool),
              ) ??
              const <SummaryMetric, bool>{},
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'tabBarScale': instance.tabBarScale,
      'swapPlusMinus': instance.swapPlusMinus,
      'summaryMetricsState': instance.summaryMetricsState
          .map((k, e) => MapEntry(_$SummaryMetricEnumMap[k]!, e)),
    };

const _$SummaryMetricEnumMap = {
  SummaryMetric.start: 'start',
  SummaryMetric.end: 'end',
  SummaryMetric.added: 'added',
  SummaryMetric.removed: 'removed',
  SummaryMetric.difference: 'difference',
  SummaryMetric.percentChange: 'percentChange',
  SummaryMetric.averagePerDay: 'averagePerDay',
  SummaryMetric.averagePerDayAdded: 'averagePerDayAdded',
  SummaryMetric.averagePerDayRemoved: 'averagePerDayRemoved',
  SummaryMetric.maxValue: 'maxValue',
  SummaryMetric.minValue: 'minValue',
};
