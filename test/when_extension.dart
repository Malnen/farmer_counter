import 'package:mocktail/mocktail.dart';

extension WhenExtension on When<void> {
  void thenDoNothing() => thenAnswer((_) async => Future<void>.value());
}
