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

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          const Icon(
            Icons.zoom_out,
            size: 18,
          ),
          SizedBox(
            width: 120,
            child: ValueListenableBuilder<double>(
              valueListenable: scale,
              builder: (BuildContext context, double value, _) => Slider(
                min: minScale,
                max: maxScale,
                value: value.clamp(minScale, maxScale),
                onChanged: (double newValue) => scale.value = newValue,
              ),
            ),
          ),
          const Icon(
            Icons.zoom_in,
            size: 18,
          ),
        ],
      );
}
