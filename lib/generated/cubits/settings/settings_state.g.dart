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
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'tabBarScale': instance.tabBarScale,
      'swapPlusMinus': instance.swapPlusMinus,
    };
