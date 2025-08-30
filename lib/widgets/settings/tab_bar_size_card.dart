import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabBarSizeCard extends HookWidget {
  const TabBarSizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final double tabBarScale = context.watch<SettingsCubit>().state.tabBarScale;
    final ValueNotifier<double> sliderPercent = useState<double>(_scaleToPercent(tabBarScale));
    useEffect(
      () {
        sliderPercent.value = _scaleToPercent(tabBarScale);
        return null;
      },
      <Object?>[tabBarScale],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<double>(
          valueListenable: sliderPercent,
          builder: (_, double percent, __) {
            final double scale = _percentToScale(percent);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'settings.tabBarSize.title'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Slider(
                  value: percent,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label:
                      '${'settings.tabBarSize.smaller'.tr()}  ←  ${percent.toStringAsFixed(0)}%  →  ${'settings.tabBarSize.larger'.tr()}',
                  onChanged: (double v) {
                    sliderPercent.value = v; // instant label/feel
                    context.read<SettingsCubit>().setTabBarScale(_percentToScale(v)); // global change
                  },
                ),
                Text(
                  'settings.tabBarSize.current'.tr(
                    namedArgs: <String, String>{'x': (scale * 100).toStringAsFixed(0)},
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.end,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _scaleToPercent(double scale) {
    const double min = SettingsState.minScale;
    const double max = SettingsState.maxScale;

    return ((scale - min) / (max - min)) * 100.0;
  }

  double _percentToScale(double percent) {
    const double min = SettingsState.minScale;
    const double max = SettingsState.maxScale;

    return min + (percent / 100.0) * (max - min);
  }
}
