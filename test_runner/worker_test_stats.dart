import 'models/test_result.dart';

class WorkerTestStats {
  final int workerId;
  final List<TestResult> passed = <TestResult>[];
  final List<TestResult> failed = <TestResult>[];
  final List<String> failureTraces = <String>[];

  WorkerTestStats(this.workerId);

  void add(TestResult result) {
    switch (result.status) {
      case TestStatus.passed:
        passed.add(result);
        break;
      case TestStatus.failed:
        failed.add(result);
        break;
    }
  }

  void addFailureTrace(String trace) {
    failureTraces.add(trace);
  }

  void printSummary() {
    print('--- Worker $workerId summary ---');
    print('✅ Passed: ${passed.length}');
    print('❌ Failed: ${failed.length}');
    if (failed.isNotEmpty) {
      print('\nFailed tests:');
      for (final TestResult test in failed) {
        print(' - ${test.name}');
      }
    }
    if (failureTraces.isNotEmpty) {
      print('\nFailure stack traces:');
      for (final String trace in failureTraces) {
        print(trace);
        print('------------------------------');
      }
    }
  }
}
