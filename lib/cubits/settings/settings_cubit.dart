import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setTabBarScale(double scale) {
    final double clamped = scale.clamp(SettingsState.minScale, SettingsState.maxScale);
    emit(state.copyWith(tabBarScale: clamped));
  }

  void setSwapPlusMinus(bool value) => emit(state.copyWith(swapPlusMinus: value));

  @override
  SettingsState? fromJson(Map<String, Object?> json) => SettingsState.fromJson(json);

  @override
  Map<String, Object?>? toJson(SettingsState state) => state.toJson();
}
