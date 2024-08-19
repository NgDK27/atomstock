// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_price_points.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockPricePoints _$StockPricePointsFromJson(Map<String, dynamic> json) {
  return _StockPricePoints.fromJson(json);
}

/// @nodoc
mixin _$StockPricePoints {
  List<StockPricePoint> get points => throw _privateConstructorUsedError;

  /// Serializes this StockPricePoints to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockPricePoints
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockPricePointsCopyWith<StockPricePoints> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockPricePointsCopyWith<$Res> {
  factory $StockPricePointsCopyWith(
          StockPricePoints value, $Res Function(StockPricePoints) then) =
      _$StockPricePointsCopyWithImpl<$Res, StockPricePoints>;
  @useResult
  $Res call({List<StockPricePoint> points});
}

/// @nodoc
class _$StockPricePointsCopyWithImpl<$Res, $Val extends StockPricePoints>
    implements $StockPricePointsCopyWith<$Res> {
  _$StockPricePointsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockPricePoints
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
  }) {
    return _then(_value.copyWith(
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<StockPricePoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockPricePointsImplCopyWith<$Res>
    implements $StockPricePointsCopyWith<$Res> {
  factory _$$StockPricePointsImplCopyWith(_$StockPricePointsImpl value,
          $Res Function(_$StockPricePointsImpl) then) =
      __$$StockPricePointsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StockPricePoint> points});
}

/// @nodoc
class __$$StockPricePointsImplCopyWithImpl<$Res>
    extends _$StockPricePointsCopyWithImpl<$Res, _$StockPricePointsImpl>
    implements _$$StockPricePointsImplCopyWith<$Res> {
  __$$StockPricePointsImplCopyWithImpl(_$StockPricePointsImpl _value,
      $Res Function(_$StockPricePointsImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockPricePoints
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
  }) {
    return _then(_$StockPricePointsImpl(
      points: null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<StockPricePoint>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockPricePointsImpl extends _StockPricePoints {
  const _$StockPricePointsImpl({final List<StockPricePoint> points = const []})
      : _points = points,
        super._();

  factory _$StockPricePointsImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockPricePointsImplFromJson(json);

  final List<StockPricePoint> _points;
  @override
  @JsonKey()
  List<StockPricePoint> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  String toString() {
    return 'StockPricePoints(points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockPricePointsImpl &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_points));

  /// Create a copy of StockPricePoints
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockPricePointsImplCopyWith<_$StockPricePointsImpl> get copyWith =>
      __$$StockPricePointsImplCopyWithImpl<_$StockPricePointsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockPricePointsImplToJson(
      this,
    );
  }
}

abstract class _StockPricePoints extends StockPricePoints {
  const factory _StockPricePoints({final List<StockPricePoint> points}) =
      _$StockPricePointsImpl;
  const _StockPricePoints._() : super._();

  factory _StockPricePoints.fromJson(Map<String, dynamic> json) =
      _$StockPricePointsImpl.fromJson;

  @override
  List<StockPricePoint> get points;

  /// Create a copy of StockPricePoints
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockPricePointsImplCopyWith<_$StockPricePointsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
