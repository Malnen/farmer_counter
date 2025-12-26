import 'package:farmer_counter/widgets/summary/graph/chart_zoom_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_material_app.dart';
import '../../../tester_extension.dart';

void main() {
  late ValueNotifier<double> scale;
  late Widget app;

  setUp(() {
    scale = ValueNotifier<double>(1.0);
    app = TestMaterialApp(
      home: Scaffold(
        body: ChartZoomSlider(
          scale: scale,
          minScale: 1.0,
          maxScale: 4.0,
        ),
      ),
    );
  });

  testWidgets('should render slider and zoom icons', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      // when:
      await tester.pumpWidget(app);

      // then:
      final Finder slider = find.byType(Slider);
      await tester.waitForFinder(slider);
      expect(slider, findsOneWidget);
      final Finder zoomOut = find.byIcon(Icons.zoom_out);
      expect(zoomOut, findsOneWidget);
      final Finder zoomIn = find.byIcon(Icons.zoom_in);
      expect(zoomIn, findsOneWidget);
    });
  });

  testWidgets('should reflect initial scale value', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      scale.value = 2.5;

      // when:
      await tester.pumpWidget(app);

      // then:
      final Finder slider = find.byType(Slider);
      await tester.waitForFinder(slider);
      final Slider sliderWidget = tester.widget(slider);
      expect(sliderWidget.value, 2.5);
    });
  });

  testWidgets('should update scale when slider changes', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      await tester.pumpWidget(app);

      // when:
      final Finder slider = find.byType(Slider);
      await tester.waitForFinder(slider);
      final Slider sliderWidget = tester.widget(slider);
      final ValueChanged<double>? onChanged = sliderWidget.onChanged;

      onChanged?.call(3.0);
      await tester.pump();

      // then:
      expect(scale.value, 3.0);
    });
  });

  testWidgets('should clamp scale below minScale', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      scale.value = 0.5;

      // when:
      await tester.pumpWidget(app);

      // then:
      final Finder slider = find.byType(Slider);
      await tester.waitForFinder(slider);
      final Slider sliderWidget = tester.widget(slider);
      expect(sliderWidget.value, 1.0);
    });
  });

  testWidgets('should clamp scale above maxScale', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // given:
      scale.value = 10.0;

      // when:
      await tester.pumpWidget(app);

      // then:
      final Finder slider = find.byType(Slider);
      await tester.waitForFinder(slider);
      final Slider sliderWidget = tester.widget(slider);
      expect(sliderWidget.value, 4.0);
    });
  });
}
