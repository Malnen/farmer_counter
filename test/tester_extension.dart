import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_material_app.dart';

extension TesterExtension on WidgetTester {
  Future<void> waitForFinder(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
    Duration pollInterval = const Duration(milliseconds: 50),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await pump(pollInterval);
      await pumpEventQueue();
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }

    throw TestFailure(
      'Timed out after ${timeout.inSeconds}s waiting for finder: $finder',
    );
  }

  Future<void> waitForFinderToDisappear(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
    Duration pollInterval = const Duration(milliseconds: 50),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await pump(pollInterval);
      await pumpEventQueue();

      if (finder.evaluate().isEmpty) {
        return;
      }
    }

    throw TestFailure(
      'Timed out after ${timeout.inSeconds}s waiting for finder to disappear: $finder',
    );
  }

  Future<void> waitForFinderCount(
    Finder finder,
    int count, {
    Duration timeout = const Duration(seconds: 30),
    Duration pollInterval = const Duration(milliseconds: 50),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await pump(pollInterval);
      await pumpEventQueue();
      final int currentCount = finder.evaluate().length;
      if (currentCount >= count) {
        return;
      }
    }

    throw TestFailure(
      'Timed out after ${timeout.inSeconds}s waiting for '
      'finder: $finder to have count $count',
    );
  }

  Future<void> takeScreenshot(
    String fileName, {
    double pixelRatio = 1.0,
  }) async {
    final RenderRepaintBoundary boundary = TestMaterialApp.repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('Failed to capture screenshot');
    }

    final Uint8List bytes = byteData.buffer.asUint8List();
    final File file = File('test_screenshots/$fileName.png');
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
  }
}
