// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncState {
  String get remoteFileId;
  DateTime? get lastLocalModified;
  String get lastRemoteMd5;
  DateTime? get lastRemoteModified;
  DateTime? get lastSyncedAt;
  bool get needsUpload;
  bool get pendingConflict;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncStateCopyWith<SyncState> get copyWith =>
      _$SyncStateCopyWithImpl<SyncState>(this as SyncState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncState &&
            (identical(other.remoteFileId, remoteFileId) ||
                other.remoteFileId == remoteFileId) &&
            (identical(other.lastLocalModified, lastLocalModified) ||
                other.lastLocalModified == lastLocalModified) &&
            (identical(other.lastRemoteMd5, lastRemoteMd5) ||
                other.lastRemoteMd5 == lastRemoteMd5) &&
            (identical(other.lastRemoteModified, lastRemoteModified) ||
                other.lastRemoteModified == lastRemoteModified) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.needsUpload, needsUpload) ||
                other.needsUpload == needsUpload) &&
            (identical(other.pendingConflict, pendingConflict) ||
                other.pendingConflict == pendingConflict));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      remoteFileId,
      lastLocalModified,
      lastRemoteMd5,
      lastRemoteModified,
      lastSyncedAt,
      needsUpload,
      pendingConflict);

  @override
  String toString() {
    return 'SyncState(remoteFileId: $remoteFileId, lastLocalModified: $lastLocalModified, lastRemoteMd5: $lastRemoteMd5, lastRemoteModified: $lastRemoteModified, lastSyncedAt: $lastSyncedAt, needsUpload: $needsUpload, pendingConflict: $pendingConflict)';
  }
}

/// @nodoc
abstract mixin class $SyncStateCopyWith<$Res> {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) _then) =
      _$SyncStateCopyWithImpl;
  @useResult
  $Res call(
      {String remoteFileId,
      DateTime? lastLocalModified,
      String lastRemoteMd5,
      DateTime? lastRemoteModified,
      DateTime? lastSyncedAt,
      bool needsUpload,
      bool pendingConflict});
}

/// @nodoc
class _$SyncStateCopyWithImpl<$Res> implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._self, this._then);

  final SyncState _self;
  final $Res Function(SyncState) _then;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remoteFileId = null,
    Object? lastLocalModified = freezed,
    Object? lastRemoteMd5 = null,
    Object? lastRemoteModified = freezed,
    Object? lastSyncedAt = freezed,
    Object? needsUpload = null,
    Object? pendingConflict = null,
  }) {
    return _then(SyncState(
      remoteFileId: null == remoteFileId
          ? _self.remoteFileId
          : remoteFileId // ignore: cast_nullable_to_non_nullable
              as String,
      lastLocalModified: freezed == lastLocalModified
          ? _self.lastLocalModified
          : lastLocalModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastRemoteMd5: null == lastRemoteMd5
          ? _self.lastRemoteMd5
          : lastRemoteMd5 // ignore: cast_nullable_to_non_nullable
              as String,
      lastRemoteModified: freezed == lastRemoteModified
          ? _self.lastRemoteModified
          : lastRemoteModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _self.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsUpload: null == needsUpload
          ? _self.needsUpload
          : needsUpload // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingConflict: null == pendingConflict
          ? _self.pendingConflict
          : pendingConflict // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}

// dart format on
