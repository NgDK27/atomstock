// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_portfolio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockPortfolioModel _$StockPortfolioModelFromJson(Map<String, dynamic> json) {
  return _StockPortfolioModel.fromJson(json);
}

/// @nodoc
mixin _$StockPortfolioModel {
  @JsonKey(name: "symbol")
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: "shares")
  double get shares => throw _privateConstructorUsedError;
  @JsonKey(name: "shares")
  set shares(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "price")
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: "price")
  set price(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "current_price")
  double get currentPrice => throw _privateConstructorUsedError;
  @JsonKey(name: "current_price")
  set currentPrice(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "value")
  double get value => throw _privateConstructorUsedError;
  @JsonKey(name: "value")
  set value(double value) => throw _privateConstructorUsedError;

  /// Serializes this StockPortfolioModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockPortfolioModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockPortfolioModelCopyWith<StockPortfolioModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockPortfolioModelCopyWith<$Res> {
  factory $StockPortfolioModelCopyWith(
          StockPortfolioModel value, $Res Function(StockPortfolioModel) then) =
      _$StockPortfolioModelCopyWithImpl<$Res, StockPortfolioModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "symbol") String symbol,
      @JsonKey(name: "shares") double shares,
      @JsonKey(name: "price") double price,
      @JsonKey(name: "current_price") double currentPrice,
      @JsonKey(name: "value") double value});
}

/// @nodoc
class _$StockPortfolioModelCopyWithImpl<$Res, $Val extends StockPortfolioModel>
    implements $StockPortfolioModelCopyWith<$Res> {
  _$StockPortfolioModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockPortfolioModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? shares = null,
    Object? price = null,
    Object? currentPrice = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockPortfolioModelImplCopyWith<$Res>
    implements $StockPortfolioModelCopyWith<$Res> {
  factory _$$StockPortfolioModelImplCopyWith(_$StockPortfolioModelImpl value,
          $Res Function(_$StockPortfolioModelImpl) then) =
      __$$StockPortfolioModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "symbol") String symbol,
      @JsonKey(name: "shares") double shares,
      @JsonKey(name: "price") double price,
      @JsonKey(name: "current_price") double currentPrice,
      @JsonKey(name: "value") double value});
}

/// @nodoc
class __$$StockPortfolioModelImplCopyWithImpl<$Res>
    extends _$StockPortfolioModelCopyWithImpl<$Res, _$StockPortfolioModelImpl>
    implements _$$StockPortfolioModelImplCopyWith<$Res> {
  __$$StockPortfolioModelImplCopyWithImpl(_$StockPortfolioModelImpl _value,
      $Res Function(_$StockPortfolioModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockPortfolioModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? shares = null,
    Object? price = null,
    Object? currentPrice = null,
    Object? value = null,
  }) {
    return _then(_$StockPortfolioModelImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockPortfolioModelImpl
    with DiagnosticableTreeMixin
    implements _StockPortfolioModel {
  _$StockPortfolioModelImpl(
      {@JsonKey(name: "symbol") required this.symbol,
      @JsonKey(name: "shares") required this.shares,
      @JsonKey(name: "price") required this.price,
      @JsonKey(name: "current_price") required this.currentPrice,
      @JsonKey(name: "value") required this.value});

  factory _$StockPortfolioModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockPortfolioModelImplFromJson(json);

  @override
  @JsonKey(name: "symbol")
  final String symbol;
  @override
  @JsonKey(name: "shares")
  double shares;
  @override
  @JsonKey(name: "price")
  double price;
  @override
  @JsonKey(name: "current_price")
  double currentPrice;
  @override
  @JsonKey(name: "value")
  double value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StockPortfolioModel(symbol: $symbol, shares: $shares, price: $price, currentPrice: $currentPrice, value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StockPortfolioModel'))
      ..add(DiagnosticsProperty('symbol', symbol))
      ..add(DiagnosticsProperty('shares', shares))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('currentPrice', currentPrice))
      ..add(DiagnosticsProperty('value', value));
  }

  /// Create a copy of StockPortfolioModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockPortfolioModelImplCopyWith<_$StockPortfolioModelImpl> get copyWith =>
      __$$StockPortfolioModelImplCopyWithImpl<_$StockPortfolioModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockPortfolioModelImplToJson(
      this,
    );
  }
}

abstract class _StockPortfolioModel implements StockPortfolioModel {
  factory _StockPortfolioModel(
          {@JsonKey(name: "symbol") required final String symbol,
          @JsonKey(name: "shares") required double shares,
          @JsonKey(name: "price") required double price,
          @JsonKey(name: "current_price") required double currentPrice,
          @JsonKey(name: "value") required double value}) =
      _$StockPortfolioModelImpl;

  factory _StockPortfolioModel.fromJson(Map<String, dynamic> json) =
      _$StockPortfolioModelImpl.fromJson;

  @override
  @JsonKey(name: "symbol")
  String get symbol;
  @override
  @JsonKey(name: "shares")
  double get shares;
  @JsonKey(name: "shares")
  set shares(double value);
  @override
  @JsonKey(name: "price")
  double get price;
  @JsonKey(name: "price")
  set price(double value);
  @override
  @JsonKey(name: "current_price")
  double get currentPrice;
  @JsonKey(name: "current_price")
  set currentPrice(double value);
  @override
  @JsonKey(name: "value")
  double get value;
  @JsonKey(name: "value")
  set value(double value);

  /// Create a copy of StockPortfolioModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockPortfolioModelImplCopyWith<_$StockPortfolioModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
