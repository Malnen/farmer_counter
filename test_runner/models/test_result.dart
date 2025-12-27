enum TestStatus { passed, failed }

class TestResult {
  final int id;
  final String name;
  final TestStatus status;

  TestResult({
    required this.id,
    required this.name,
    required this.status,
  });
}
