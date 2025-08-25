// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, always_specify_types, unused_element, unnecessary_non_null_assertion

part of '../../models/sync_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncState _$SyncStateFromJson(Map<String, dynamic> json) => SyncState(
      remoteFileId: json['remoteFileId'] as String,
      lastLocalModified: json['lastLocalModified'] == null
          ? null
          : DateTime.parse(json['lastLocalModified'] as String),
      lastRemoteMd5: json['lastRemoteMd5'] as String? ?? '',
      lastRemoteModified: json['lastRemoteModified'] == null
          ? null
          : DateTime.parse(json['lastRemoteModified'] as String),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      needsUpload: json['needsUpload'] as bool? ?? false,
      pendingConflict: json['pendingConflict'] as bool? ?? false,
    );

Map<String, dynamic> _$SyncStateToJson(SyncState instance) => <String, dynamic>{
      'remoteFileId': instance.remoteFileId,
      'lastLocalModified': instance.lastLocalModified?.toIso8601String(),
      'lastRemoteMd5': instance.lastRemoteMd5,
      'lastRemoteModified': instance.lastRemoteModified?.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'needsUpload': instance.needsUpload,
      'pendingConflict': instance.pendingConflict,
    };
