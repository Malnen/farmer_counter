import 'package:hydrated_bloc/hydrated_bloc.dart';

class InMemoryStorage implements Storage {
  final Map<String, Object?> _store = <String, Object?>{};

  @override
  dynamic read(String key) => _store[key];

  @override
  Future<void> write(String key, Object? value) async => _store[key] = value;

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();

  @override
  Future<void> close() async {}
}
