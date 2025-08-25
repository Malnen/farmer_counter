import 'package:farmer_counter/widgets/round_icon.dart';
import 'package:flutter/material.dart';

class CounterCard extends StatelessWidget {
  final String name;
  final int count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const CounterCard({
    required this.name,
    required this.count,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: <Widget>[
            RoundIcon(
              icon: Icons.remove,
              onTap: onMinus,
            ),
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
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            RoundIcon(
              icon: Icons.add,
              onTap: onPlus,
            ),
          ],
        ),
      ),
    );
  }
}
