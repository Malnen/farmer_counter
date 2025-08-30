import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScaleAwareBottomBar extends StatelessWidget {
  final List<Widget> tabs;

  const ScaleAwareBottomBar({required this.tabs});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, double>(
      selector: (SettingsState state) => state.tabBarScale,
      builder: (BuildContext context, double tabBarScale) => Container(
        color: Theme.of(context).colorScheme.outlineVariant,
        height: kBottomNavigationBarHeight * tabBarScale,
        child: TabBar(tabs: tabs),
      ),
    );
  }
}
