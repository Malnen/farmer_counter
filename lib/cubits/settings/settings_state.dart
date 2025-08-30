import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/cubits/settings/settings_state.freezed.dart';

part '../../generated/cubits/settings/settings_state.g.dart';

@freezed
@JsonSerializable()
class SettingsState with _$SettingsState {
  static const double minScale = .80;
  static const double maxScale = 1.80;

  @override
  final double tabBarScale;
  @override
  final bool swapPlusMinus;

  const SettingsState({
    this.tabBarScale = 1.25,
    this.swapPlusMinus = false,
  });

  factory SettingsState.fromJson(Map<String, Object?> json) => _$SettingsStateFromJson(json);

  Map<String, Object?> toJson() => _$SettingsStateToJson(this);
}
