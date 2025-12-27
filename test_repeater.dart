import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'test_runner/machine_output_processor.dart';
import 'test_runner/worker_table_renderer.dart';
import 'test_runner/worker_test_stats.dart';

bool _isCompilerRace(String text) {
  return text.contains('PathExistsException') && text.contains('test_cache');
}

Future<void> main(List<String> args) async {
  final int repeatCount = args.isNotEmpty ? int.tryParse(args[0]) ?? 1 : 1;
  final int instances = args.length > 1 ? int.tryParse(args[1]) ?? 1 : 1;
  if (repeatCount < 1 || instances < 1) {
    stderr.writeln('repeatCount and instances must be >= 1');
    exit(1);
  }

  stdout.writeln(
    'Running $repeatCount test runs with $instances parallel instances',
  );

  final StreamController<int> queue = StreamController<int>.broadcast();
  final List<Future<void>> workers = <Future<void>>[];

  final WorkerTableRenderer table = WorkerTableRenderer(instances);
  final Map<int, WorkerTestStats> allStats = <int, WorkerTestStats>{};
  final Map<int, DateTime> startTimes = <int, DateTime>{};
  final Map<int, int> completedRuns = <int, int>{};
  final Map<int, int> currentRuns = <int, int>{};

  void renderTable() {
    table.render(
      List<WorkerRow>.generate(
        instances,
        (int i) {
          final int workerId = i + 1;
          final WorkerTestStats? stats = allStats[workerId];
          final DateTime? start = startTimes[workerId];
          final Duration elapsed = start == null ? Duration.zero : DateTime.now().difference(start);

          return WorkerRow(
            workerId: workerId,
            passed: stats?.passed.length ?? 0,
            failed: stats?.failed.length ?? 0,
            currentRun: currentRuns[workerId] ?? 0,
            elapsed: elapsed,
            completedRuns: completedRuns[workerId] ?? 0,
          );
        },
      ),
    );
  }

  table.render(
    List<WorkerRow>.generate(
      instances,
      (int i) => WorkerRow(
        workerId: i + 1,
        passed: 0,
        failed: 0,
        currentRun: 0,
        elapsed: Duration.zero,
        completedRuns: 0,
      ),
    ),
  );

  Future<void> worker(int workerId) async {
    final WorkerTestStats stats = WorkerTestStats(workerId);
    final MachineOutputProcessor processor = MachineOutputProcessor(stats);

    allStats[workerId] = stats;
    startTimes[workerId] = DateTime.now();
    completedRuns[workerId] = 0;
    currentRuns[workerId] = 0;

    processor.onUpdate = renderTable;

    await for (final int runId in queue.stream) {
      currentRuns[workerId] = runId;
      renderTable();

      final StringBuffer stderrBuffer = StringBuffer();

      final Process process = await Process.start(
        'fvm',
        const <String>['flutter', 'test', '--machine'],
        runInShell: true,
      );

      process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(processor.processLine);

      process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen((String line) {
        stderrBuffer.writeln(line);
        stderr.writeln('[RUN $runId | W$workerId] $line');
      });

      final int exitCode = await process.exitCode;

      if (exitCode != 0) {
        final String stderrText = stderrBuffer.toString();

        if (_isCompilerRace(stderrText)) {
          await Future<void>.delayed(
            Duration(milliseconds: 500 + workerId * 200),
          );
          queue.add(runId);
          continue;
        }

        stderr.writeln('\n❌ Tests failed on run $runId\n');

        for (final WorkerTestStats stats in allStats.values) {
          if (stats.failureTraces.isEmpty) continue;
          stderr.writeln('--- Worker ${stats.workerId} failures ---');
          for (final String trace in stats.failureTraces) {
            stderr.writeln(trace);
            stderr.writeln('------------------------------');
          }
        }

        exit(exitCode);
      }

      completedRuns[workerId] = completedRuns[workerId]! + 1;
      renderTable();
    }
  }

  for (int i = 1; i <= instances; i++) {
    workers.add(worker(i));
  }

  for (int i = 1; i <= repeatCount; i++) {
    queue.add(i);
  }

  await queue.close();
  await Future.wait(workers);

  stdout.writeln('\n✅ All $repeatCount runs passed');
}
