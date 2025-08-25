import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/sync_state.freezed.dart';
part '../generated/models/sync_state.g.dart';

@freezed
@JsonSerializable()
class SyncState with _$SyncState {
  @override
  final String remoteFileId;
  @override
  final DateTime? lastLocalModified;
  @override
  final String lastRemoteMd5;
  @override
  final DateTime? lastRemoteModified;
  @override
  final DateTime? lastSyncedAt;
  @override
  final bool needsUpload;
  @override
  final bool pendingConflict;

  SyncState({
    required this.remoteFileId,
    this.lastLocalModified,
    this.lastRemoteMd5 = '',
    this.lastRemoteModified,
    this.lastSyncedAt,
    this.needsUpload = false,
    this.pendingConflict = false,
  });

  factory SyncState.empty() => SyncState(
    remoteFileId: '',
    lastRemoteMd5: '',
  );

  factory SyncState.fromJson(Map<String, Object?> json) =>
      _$SyncStateFromJson(json);

  Map<String, Object?> toJson() => _$SyncStateToJson(this);
}
