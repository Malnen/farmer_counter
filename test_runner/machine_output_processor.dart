import 'dart:convert';
import 'dart:io';

import 'models/test_result.dart';
import 'worker_test_stats.dart';

class MachineOutputProcessor {
  final WorkerTestStats stats;
  final Map<int, String> _testNames = <int, String>{};

  void Function()? onUpdate;

  MachineOutputProcessor(this.stats);

  void processLine(String line) {
    final String trimmed = line.trim();
    if (!trimmed.startsWith('{')) {
      return;
    }

    Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } catch (_) {
      return;
    }

    if (decoded is! Map<String, Object?>) return;

    final Object? typeValue = decoded['type'];
    if (typeValue is! String) return;

    switch (typeValue) {
      case 'testStart':
        final Object? testObj = decoded['test'];
        if (testObj is Map<String, Object?>) {
          final Object? id = testObj['id'];
          final Object? name = testObj['name'];
          if (id is int && name is String) {
            _testNames[id] = name;
          }
        }
        break;

      case 'testDone':
        _handleTestDone(decoded);
        break;

      case 'error':
        _handleError(decoded);
        break;
    }
  }

  void _handleTestDone(Map<String, Object?> event) {
    final Object? testIdObj = event['testID'];
    final Object? resultObj = event['result'];
    final Object? hiddenObj = event['hidden'];

    if (testIdObj is! int || resultObj is! String) return;
    if (hiddenObj is bool && hiddenObj) return;

    final String name = _testNames[testIdObj] ?? 'unknown test $testIdObj';

    final TestStatus status = resultObj == 'success' ? TestStatus.passed : TestStatus.failed;

    stats.add(
      TestResult(
        id: testIdObj,
        name: name,
        status: status,
      ),
    );

    onUpdate?.call();
  }

  void _handleError(Map<String, Object?> event) {
    final Object? error = event['error'];
    final Object? stack = event['stackTrace'];

    final StringBuffer buffer = StringBuffer();

    if (error is String) {
      buffer.writeln(error);
    }

    if (stack is String) {
      buffer.writeln(stack);
    }

    if (buffer.isNotEmpty) {
      stats.addFailureTrace(buffer.toString());
      print(buffer.toString());
      exit(1);
    }
  }
}
