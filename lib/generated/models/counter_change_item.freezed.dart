// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/counter_change_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CounterChangeItem {
  Id get id;
  String get counterGuid;
  DateTime get at;
  int get delta;
  int get newValue;

  /// Create a copy of CounterChangeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CounterChangeItemCopyWith<CounterChangeItem> get copyWith =>
      _$CounterChangeItemCopyWithImpl<CounterChangeItem>(
          this as CounterChangeItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CounterChangeItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.counterGuid, counterGuid) ||
                other.counterGuid == counterGuid) &&
            (identical(other.at, at) || other.at == at) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, counterGuid, at, delta, newValue);

  @override
  String toString() {
    return 'CounterChangeItem(id: $id, counterGuid: $counterGuid, at: $at, delta: $delta, newValue: $newValue)';
  }
}

/// @nodoc
abstract mixin class $CounterChangeItemCopyWith<$Res> {
  factory $CounterChangeItemCopyWith(
          CounterChangeItem value, $Res Function(CounterChangeItem) _then) =
      _$CounterChangeItemCopyWithImpl;
  @useResult
  $Res call({int id, String counterGuid, DateTime at, int delta, int newValue});
}

/// @nodoc
class _$CounterChangeItemCopyWithImpl<$Res>
    implements $CounterChangeItemCopyWith<$Res> {
  _$CounterChangeItemCopyWithImpl(this._self, this._then);

  final CounterChangeItem _self;
  final $Res Function(CounterChangeItem) _then;

  /// Create a copy of CounterChangeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? counterGuid = null,
    Object? at = null,
    Object? delta = null,
    Object? newValue = null,
  }) {
    return _then(CounterChangeItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      counterGuid: null == counterGuid
          ? _self.counterGuid
          : counterGuid // ignore: cast_nullable_to_non_nullable
              as String,
      at: null == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      delta: null == delta
          ? _self.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      newValue: null == newValue
          ? _self.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [CounterChangeItem].
extension CounterChangeItemPatterns on CounterChangeItem {
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
