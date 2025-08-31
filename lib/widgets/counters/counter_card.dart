import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/widgets/counters/counter_card_actions.dart';
import 'package:farmer_counter/widgets/round_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterCard extends HookWidget {
  final String name;
  final int count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final void Function(int delta)? onBulkAdjust;
  final VoidCallback? onReverseLast;

  const CounterCard({
    required this.name,
    required this.count,
    required this.onMinus,
    required this.onPlus,
    this.onBulkAdjust,
    this.onReverseLast,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool swapped = context.select<SettingsCubit, bool>(
      (SettingsCubit cubit) => cubit.state.swapPlusMinus,
    );
    final RoundIcon minus = RoundIcon(icon: Icons.remove, onTap: onMinus);
    final RoundIcon plus = RoundIcon(icon: Icons.add, onTap: onPlus);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: <Widget>[
                if (swapped) plus else minus,
                Expanded(
                  child: Column(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(scale: animation, child: child),
                        child: Text(
                          '$count',
                          key: ValueKey<int>(count),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (swapped) minus else plus,
              ],
            ),
          ),
          CounterCardActions(
            onBulkAdjust: onBulkAdjust,
            onReverseLast: onReverseLast,
          ),
        ],
      ),
    );
  }
}
