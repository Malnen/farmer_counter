  import 'package:farmer_counter/widgets/hold_repeat_icon/hold_repeat_icon.dart';
  import 'package:flutter/material.dart';

  class ChartZoomSlider extends StatelessWidget {
    final ValueNotifier<double> scale;
    final double minScale;
    final double maxScale;

    const ChartZoomSlider({
      required this.scale,
      required this.minScale,
      required this.maxScale,
    });

    double get _step => (maxScale - minScale) / 10;

    @override
    Widget build(BuildContext context) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: Row(
          children: <Widget>[
            HoldRepeatIcon(
              hitboxSize: 28,
              iconSize: 28,
              icon: Icons.zoom_out,
              onStep: _zoomOut,
            ),
            ValueListenableBuilder<double>(
              valueListenable: scale,
              builder: (BuildContext context, double value, _) => Slider(
                min: minScale,
                max: maxScale,
                value: value.clamp(minScale, maxScale),
                onChanged: (double newValue) => scale.value = newValue,
              ),
            ),
            HoldRepeatIcon(
              hitboxSize: 28,
              iconSize: 28,
              icon: Icons.zoom_in,
              onStep: _zoomIn,
            ),
          ],
        ),
      );
    }

    void _zoomOut() => scale.value = (scale.value - _step).clamp(minScale, maxScale);

    void _zoomIn() => scale.value = (scale.value + _step).clamp(minScale, maxScale);
  }
