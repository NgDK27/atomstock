// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockModel _$StockModelFromJson(Map<String, dynamic> json) {
  return _StockModel.fromJson(json);
}

/// @nodoc
mixin _$StockModel {
// required final String id,
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: "Symbol")
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: "Price")
  double get currentPrice => throw _privateConstructorUsedError;
  @JsonKey(name: "Price")
  set currentPrice(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "Change")
  double get priceChange => throw _privateConstructorUsedError;
  @JsonKey(name: "Change")
  set priceChange(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "RatioChange")
  double get percentChange => throw _privateConstructorUsedError;
  @JsonKey(name: "RatioChange")
  set percentChange(double value) => throw _privateConstructorUsedError;
  double? get floor => throw _privateConstructorUsedError;
  set floor(double? value) => throw _privateConstructorUsedError;
  double? get ceiling => throw _privateConstructorUsedError;
  set ceiling(double? value) => throw _privateConstructorUsedError;
  @JsonKey(name: "Volume")
  double? get totalVolume => throw _privateConstructorUsedError;
  @JsonKey(name: "Volume")
  set totalVolume(double? value) => throw _privateConstructorUsedError;
  double? get totalValue => throw _privateConstructorUsedError;
  set totalValue(double? value) => throw _privateConstructorUsedError;
  double? get open => throw _privateConstructorUsedError;
  set open(double? value) => throw _privateConstructorUsedError;
  double? get close => throw _privateConstructorUsedError;
  set close(double? value) => throw _privateConstructorUsedError;
  double? get high => throw _privateConstructorUsedError;
  set high(double? value) => throw _privateConstructorUsedError;
  double? get low => throw _privateConstructorUsedError;
  set low(double? value) => throw _privateConstructorUsedError;
  ExchangeModel? get exchange => throw _privateConstructorUsedError;
  set exchange(ExchangeModel? value) => throw _privateConstructorUsedError;
  StockPricePoints? get pricePoints => throw _privateConstructorUsedError;
  set pricePoints(StockPricePoints? value) =>
      throw _privateConstructorUsedError;

  /// Serializes this StockModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockModelCopyWith<StockModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockModelCopyWith<$Res> {
  factory $StockModelCopyWith(
          StockModel value, $Res Function(StockModel) then) =
      _$StockModelCopyWithImpl<$Res, StockModel>;
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: "Symbol") String symbol,
      @JsonKey(name: "Price") double currentPrice,
      @JsonKey(name: "Change") double priceChange,
      @JsonKey(name: "RatioChange") double percentChange,
      double? floor,
      double? ceiling,
      @JsonKey(name: "Volume") double? totalVolume,
      double? totalValue,
      double? open,
      double? close,
      double? high,
      double? low,
      ExchangeModel? exchange,
      StockPricePoints? pricePoints});

  $ExchangeModelCopyWith<$Res>? get exchange;
  $StockPricePointsCopyWith<$Res>? get pricePoints;
}

/// @nodoc
class _$StockModelCopyWithImpl<$Res, $Val extends StockModel>
    implements $StockModelCopyWith<$Res> {
  _$StockModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = null,
    Object? currentPrice = null,
    Object? priceChange = null,
    Object? percentChange = null,
    Object? floor = freezed,
    Object? ceiling = freezed,
    Object? totalVolume = freezed,
    Object? totalValue = freezed,
    Object? open = freezed,
    Object? close = freezed,
    Object? high = freezed,
    Object? low = freezed,
    Object? exchange = freezed,
    Object? pricePoints = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      priceChange: null == priceChange
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as double,
      percentChange: null == percentChange
          ? _value.percentChange
          : percentChange // ignore: cast_nullable_to_non_nullable
              as double,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as double?,
      ceiling: freezed == ceiling
          ? _value.ceiling
          : ceiling // ignore: cast_nullable_to_non_nullable
              as double?,
      totalVolume: freezed == totalVolume
          ? _value.totalVolume
          : totalVolume // ignore: cast_nullable_to_non_nullable
              as double?,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      open: freezed == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double?,
      close: freezed == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as double?,
      high: freezed == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double?,
      low: freezed == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double?,
      exchange: freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as ExchangeModel?,
      pricePoints: freezed == pricePoints
          ? _value.pricePoints
          : pricePoints // ignore: cast_nullable_to_non_nullable
              as StockPricePoints?,
    ) as $Val);
  }

  /// Create a copy of StockModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExchangeModelCopyWith<$Res>? get exchange {
    if (_value.exchange == null) {
      return null;
    }

    return $ExchangeModelCopyWith<$Res>(_value.exchange!, (value) {
      return _then(_value.copyWith(exchange: value) as $Val);
    });
  }

  /// Create a copy of StockModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockPricePointsCopyWith<$Res>? get pricePoints {
    if (_value.pricePoints == null) {
      return null;
    }

    return $StockPricePointsCopyWith<$Res>(_value.pricePoints!, (value) {
      return _then(_value.copyWith(pricePoints: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockModelImplCopyWith<$Res>
    implements $StockModelCopyWith<$Res> {
  factory _$$StockModelImplCopyWith(
          _$StockModelImpl value, $Res Function(_$StockModelImpl) then) =
      __$$StockModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: "Symbol") String symbol,
      @JsonKey(name: "Price") double currentPrice,
      @JsonKey(name: "Change") double priceChange,
      @JsonKey(name: "RatioChange") double percentChange,
      double? floor,
      double? ceiling,
      @JsonKey(name: "Volume") double? totalVolume,
      double? totalValue,
      double? open,
      double? close,
      double? high,
      double? low,
      ExchangeModel? exchange,
      StockPricePoints? pricePoints});

  @override
  $ExchangeModelCopyWith<$Res>? get exchange;
  @override
  $StockPricePointsCopyWith<$Res>? get pricePoints;
}

/// @nodoc
class __$$StockModelImplCopyWithImpl<$Res>
    extends _$StockModelCopyWithImpl<$Res, _$StockModelImpl>
    implements _$$StockModelImplCopyWith<$Res> {
  __$$StockModelImplCopyWithImpl(
      _$StockModelImpl _value, $Res Function(_$StockModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = null,
    Object? currentPrice = null,
    Object? priceChange = null,
    Object? percentChange = null,
    Object? floor = freezed,
    Object? ceiling = freezed,
    Object? totalVolume = freezed,
    Object? totalValue = freezed,
    Object? open = freezed,
    Object? close = freezed,
    Object? high = freezed,
    Object? low = freezed,
    Object? exchange = freezed,
    Object? pricePoints = freezed,
  }) {
    return _then(_$StockModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      priceChange: null == priceChange
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as double,
      percentChange: null == percentChange
          ? _value.percentChange
          : percentChange // ignore: cast_nullable_to_non_nullable
              as double,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as double?,
      ceiling: freezed == ceiling
          ? _value.ceiling
          : ceiling // ignore: cast_nullable_to_non_nullable
              as double?,
      totalVolume: freezed == totalVolume
          ? _value.totalVolume
          : totalVolume // ignore: cast_nullable_to_non_nullable
              as double?,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      open: freezed == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double?,
      close: freezed == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as double?,
      high: freezed == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double?,
      low: freezed == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double?,
      exchange: freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as ExchangeModel?,
      pricePoints: freezed == pricePoints
          ? _value.pricePoints
          : pricePoints // ignore: cast_nullable_to_non_nullable
              as StockPricePoints?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockModelImpl extends _StockModel with DiagnosticableTreeMixin {
  _$StockModelImpl(
      {this.name = "Stock Name",
      @JsonKey(name: "Symbol") required this.symbol,
      @JsonKey(name: "Price") required this.currentPrice,
      @JsonKey(name: "Change") required this.priceChange,
      @JsonKey(name: "RatioChange") required this.percentChange,
      this.floor,
      this.ceiling,
      @JsonKey(name: "Volume") this.totalVolume,
      this.totalValue,
      this.open,
      this.close,
      this.high,
      this.low,
      this.exchange,
      this.pricePoints})
      : super._();

  factory _$StockModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockModelImplFromJson(json);

// required final String id,
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey(name: "Symbol")
  final String symbol;
  @override
  @JsonKey(name: "Price")
  double currentPrice;
  @override
  @JsonKey(name: "Change")
  double priceChange;
  @override
  @JsonKey(name: "RatioChange")
  double percentChange;
  @override
  double? floor;
  @override
  double? ceiling;
  @override
  @JsonKey(name: "Volume")
  double? totalVolume;
  @override
  double? totalValue;
  @override
  double? open;
  @override
  double? close;
  @override
  double? high;
  @override
  double? low;
  @override
  ExchangeModel? exchange;
  @override
  StockPricePoints? pricePoints;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StockModel(name: $name, symbol: $symbol, currentPrice: $currentPrice, priceChange: $priceChange, percentChange: $percentChange, floor: $floor, ceiling: $ceiling, totalVolume: $totalVolume, totalValue: $totalValue, open: $open, close: $close, high: $high, low: $low, exchange: $exchange, pricePoints: $pricePoints)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StockModel'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('symbol', symbol))
      ..add(DiagnosticsProperty('currentPrice', currentPrice))
      ..add(DiagnosticsProperty('priceChange', priceChange))
      ..add(DiagnosticsProperty('percentChange', percentChange))
      ..add(DiagnosticsProperty('floor', floor))
      ..add(DiagnosticsProperty('ceiling', ceiling))
      ..add(DiagnosticsProperty('totalVolume', totalVolume))
      ..add(DiagnosticsProperty('totalValue', totalValue))
      ..add(DiagnosticsProperty('open', open))
      ..add(DiagnosticsProperty('close', close))
      ..add(DiagnosticsProperty('high', high))
      ..add(DiagnosticsProperty('low', low))
      ..add(DiagnosticsProperty('exchange', exchange))
      ..add(DiagnosticsProperty('pricePoints', pricePoints));
  }

  /// Create a copy of StockModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockModelImplCopyWith<_$StockModelImpl> get copyWith =>
      __$$StockModelImplCopyWithImpl<_$StockModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockModelImplToJson(
      this,
    );
  }
}

abstract class _StockModel extends StockModel {
  factory _StockModel(
      {final String name,
      @JsonKey(name: "Symbol") required final String symbol,
      @JsonKey(name: "Price") required double currentPrice,
      @JsonKey(name: "Change") required double priceChange,
      @JsonKey(name: "RatioChange") required double percentChange,
      double? floor,
      double? ceiling,
      @JsonKey(name: "Volume") double? totalVolume,
      double? totalValue,
      double? open,
      double? close,
      double? high,
      double? low,
      ExchangeModel? exchange,
      StockPricePoints? pricePoints}) = _$StockModelImpl;
  _StockModel._() : super._();

  factory _StockModel.fromJson(Map<String, dynamic> json) =
      _$StockModelImpl.fromJson;

// required final String id,
  @override
  String get name;
  @override
  @JsonKey(name: "Symbol")
  String get symbol;
  @override
  @JsonKey(name: "Price")
  double get currentPrice;
  @JsonKey(name: "Price")
  set currentPrice(double value);
  @override
  @JsonKey(name: "Change")
  double get priceChange;
  @JsonKey(name: "Change")
  set priceChange(double value);
  @override
  @JsonKey(name: "RatioChange")
  double get percentChange;
  @JsonKey(name: "RatioChange")
  set percentChange(double value);
  @override
  double? get floor;
  set floor(double? value);
  @override
  double? get ceiling;
  set ceiling(double? value);
  @override
  @JsonKey(name: "Volume")
  double? get totalVolume;
  @JsonKey(name: "Volume")
  set totalVolume(double? value);
  @override
  double? get totalValue;
  set totalValue(double? value);
  @override
  double? get open;
  set open(double? value);
  @override
  double? get close;
  set close(double? value);
  @override
  double? get high;
  set high(double? value);
  @override
  double? get low;
  set low(double? value);
  @override
  ExchangeModel? get exchange;
  set exchange(ExchangeModel? value);
  @override
  StockPricePoints? get pricePoints;
  set pricePoints(StockPricePoints? value);

  /// Create a copy of StockModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockModelImplCopyWith<_$StockModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
