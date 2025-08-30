import 'package:bloc_test/bloc_test.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SettingsCubit cubit;

  setUp(() {
    cubit = SettingsCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('SettingsCubit', () {
    test('initial state', () {
      // given:
      // when:
      // then:
      expect(cubit.state, const SettingsState());
      expect(cubit.state.tabBarScale, 1.25);
      expect(cubit.state.swapPlusMinus, false);
    });

    blocTest<SettingsCubit, SettingsState>(
      'emits clamped tabBarScale when setTabBarScale called',
      build: SettingsCubit.new,
      act: (SettingsCubit c) => c.setTabBarScale(100),
      expect: () => <SettingsState>[
        const SettingsState(
          tabBarScale: SettingsState.maxScale,
          swapPlusMinus: false,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'emits new tabBarScale within range',
      build: SettingsCubit.new,
      act: (SettingsCubit cubit) => cubit.setTabBarScale(1.45),
      expect: () => <SettingsState>[const SettingsState(tabBarScale: 1.45, swapPlusMinus: false)],
    );

    blocTest<SettingsCubit, SettingsState>(
      'emits new swapPlusMinus state',
      build: SettingsCubit.new,
      act: (SettingsCubit cubit) => cubit.setSwapPlusMinus(true),
      expect: () => <SettingsState>[const SettingsState(tabBarScale: 1.25, swapPlusMinus: true)],
    );
  });
}
