// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_price_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockPricePoint _$StockPricePointFromJson(Map<String, dynamic> json) {
  return _StockPricePoint.fromJson(json);
}

/// @nodoc
mixin _$StockPricePoint {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this StockPricePoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockPricePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockPricePointCopyWith<StockPricePoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockPricePointCopyWith<$Res> {
  factory $StockPricePointCopyWith(
          StockPricePoint value, $Res Function(StockPricePoint) then) =
      _$StockPricePointCopyWithImpl<$Res, StockPricePoint>;
  @useResult
  $Res call({DateTime timestamp, double price});
}

/// @nodoc
class _$StockPricePointCopyWithImpl<$Res, $Val extends StockPricePoint>
    implements $StockPricePointCopyWith<$Res> {
  _$StockPricePointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockPricePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockPricePointImplCopyWith<$Res>
    implements $StockPricePointCopyWith<$Res> {
  factory _$$StockPricePointImplCopyWith(_$StockPricePointImpl value,
          $Res Function(_$StockPricePointImpl) then) =
      __$$StockPricePointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime timestamp, double price});
}

/// @nodoc
class __$$StockPricePointImplCopyWithImpl<$Res>
    extends _$StockPricePointCopyWithImpl<$Res, _$StockPricePointImpl>
    implements _$$StockPricePointImplCopyWith<$Res> {
  __$$StockPricePointImplCopyWithImpl(
      _$StockPricePointImpl _value, $Res Function(_$StockPricePointImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockPricePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? price = null,
  }) {
    return _then(_$StockPricePointImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockPricePointImpl implements _StockPricePoint {
  const _$StockPricePointImpl({required this.timestamp, required this.price});

  factory _$StockPricePointImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockPricePointImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final double price;

  @override
  String toString() {
    return 'StockPricePoint(timestamp: $timestamp, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockPricePointImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp, price);

  /// Create a copy of StockPricePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockPricePointImplCopyWith<_$StockPricePointImpl> get copyWith =>
      __$$StockPricePointImplCopyWithImpl<_$StockPricePointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockPricePointImplToJson(
      this,
    );
  }
}

abstract class _StockPricePoint implements StockPricePoint {
  const factory _StockPricePoint(
      {required final DateTime timestamp,
      required final double price}) = _$StockPricePointImpl;

  factory _StockPricePoint.fromJson(Map<String, dynamic> json) =
      _$StockPricePointImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get price;

  /// Create a copy of StockPricePoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockPricePointImplCopyWith<_$StockPricePointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
