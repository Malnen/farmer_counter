import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HoldRepeatIcon extends HookWidget {
  final IconData icon;
  final VoidCallback onStep;
  final double iconSize;
  final double hitboxSize;

  const HoldRepeatIcon({
    required this.icon,
    required this.onStep,
    this.iconSize = 18,
    this.hitboxSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: const Duration(milliseconds: 80),
    );

    useEffect(
      () {
        controller.addListener(onStep);
        return () => controller.removeListener(onStep);
      },
      <Object?>[controller, onStep],
    );

    return GestureDetector(
      onTap: onStep,
      onTapDown: (_) => controller.repeat(),
      onTapUp: (_) => controller.stop(),
      onTapCancel: controller.stop,
      child: SizedBox(
        height: hitboxSize,
        width: hitboxSize,
        child: Icon(
          icon,
          size: iconSize,
        ),
      ),
    );
  }
}
