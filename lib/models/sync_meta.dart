import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';

part '../generated/models/sync_meta.freezed.dart';
part '../generated/models/sync_meta.g.dart';

@freezed
@Collection(ignore: <String>{'copyWith'})
class SyncMeta with _$SyncMeta {
  @override
  final Id id;
  @override
  final DateTime lastModified;

  SyncMeta({required this.id, required this.lastModified});

  factory SyncMeta.create() => SyncMeta(
        id: Isar.autoIncrement,
        lastModified: DateTime.now(),
      );
}
