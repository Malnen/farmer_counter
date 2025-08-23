import 'package:flutter/material.dart';

class RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const RoundIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        color: colorScheme.secondaryContainer,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
