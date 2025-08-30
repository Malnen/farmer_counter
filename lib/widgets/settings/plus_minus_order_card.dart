import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlusMinusOrderCard extends HookWidget {
  const PlusMinusOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool swapped = context.select<SettingsCubit, bool>((SettingsCubit cubit) => cubit.state.swapPlusMinus);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text('settings.plusMinusOrder.title'.tr()),
        value: swapped,
        onChanged: (bool value) => context.read<SettingsCubit>().setSwapPlusMinus(value),
      ),
    );
  }
}
