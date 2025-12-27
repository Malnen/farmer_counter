import 'dart:io';

class WorkerTableRenderer {
  final int workerCount;
  bool _initialized = false;

  WorkerTableRenderer(this.workerCount);

  void render(List<WorkerRow> rows) {
    if (_initialized) {
      _moveCursorUp(workerCount + 2);
    } else {
      _initialized = true;
    }

    _printHeader();
    for (final row in rows) {
      _printRow(row);
    }
  }

  void _printHeader() {
    _clearLine();
    stdout.writeln(
      'Worker | Run | Passed | Failed | Total | Elapsed | Avg/Run',
    );
    stdout.writeln(
      '-------+-----+--------+--------+-------+----------+---------',
    );
  }

  void _printRow(WorkerRow row) {
    _clearLine();
    stdout.writeln(
      '${row.workerId.toString().padRight(6)} | '
          '${row.currentRun.toString().padRight(3)} | '
          '${row.passed.toString().padRight(6)} | '
          '${row.failed.toString().padRight(6)} | '
          '${row.total.toString().padRight(5)} | '
          '${row.elapsedFormatted.padRight(8)} | '
          '${row.avgPerRunFormatted.padRight(7)}',
    );
  }

  void _moveCursorUp(int lines) {
    stdout.write('\x1B[${lines}A');
  }

  void _clearLine() {
    stdout.write('\x1B[2K\r');
  }
}

class WorkerRow {
  final int workerId;
  final int passed;
  final int failed;
  final int currentRun;
  final Duration elapsed;
  final int completedRuns;

  WorkerRow({
    required this.workerId,
    required this.passed,
    required this.failed,
    required this.currentRun,
    required this.elapsed,
    required this.completedRuns,
  });

  int get total => passed + failed;

  Duration get avgPerRun {
    if (completedRuns == 0) return Duration.zero;
    return Duration(milliseconds: elapsed.inMilliseconds ~/ completedRuns);
  }

  String get elapsedFormatted => _fmt(elapsed);
  String get avgPerRunFormatted => _fmt(avgPerRun);

  String _fmt(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
