import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ScaleListener extends HookWidget {
  final void Function()? onScaleStart;
  final void Function(double delta)? onScaleUpdate;
  final void Function()? onScaleEnd;
  final HitTestBehavior behavior;
  final Widget? child;

  const ScaleListener({
    super.key,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.behavior = HitTestBehavior.deferToChild,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ObjectRef<Offset?> pointer1 = useRef<Offset?>(null);
    final ObjectRef<Offset?> pointer2 = useRef<Offset?>(null);
    final ObjectRef<double> startDistance = useRef<double>(0);
    final ObjectRef<double> lastRaw = useRef<double>(1);
    final ObjectRef<int> count = useRef<int>(0);

    return Listener(
      behavior: behavior,
      onPointerDown: (PointerDownEvent event) {
        count.value += 1;
        if (count.value == 1) {
          pointer1.value = event.position;
        } else if (count.value == 2 && pointer1.value != null) {
          pointer2.value = event.position;
          startDistance.value = (pointer1.value! - pointer2.value!).distance;
          lastRaw.value = 1.0;
          onScaleStart?.call();
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        if (count.value == 2 && pointer1.value != null && pointer2.value != null) {
          if (event.pointer.isEven) {
            pointer2.value = event.position;
          } else {
            pointer1.value = event.position;
          }

          final double distance = (pointer1.value! - pointer2.value!).distance;
          final double raw = startDistance.value == 0 ? 1.0 : distance / startDistance.value;
          final double delta = raw / lastRaw.value;
          lastRaw.value = raw;
          onScaleUpdate?.call(delta);
        }
      },
      onPointerUp: (_) {
        count.value -= 1;
        if (count.value < 2) {
          onScaleEnd?.call();
        }
      },
      onPointerCancel: (_) {
        count.value -= 1;
        if (count.value < 2) {
          onScaleEnd?.call();
        }
      },
      child: child,
    );
  }
}
