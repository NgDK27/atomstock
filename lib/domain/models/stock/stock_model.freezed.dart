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
  String get name => throw _privateConstructorUsedError;
  String get ticker => throw _privateConstructorUsedError;
  double get currentPrice => throw _privateConstructorUsedError;
  set currentPrice(double value) => throw _privateConstructorUsedError;
  double get priceChange => throw _privateConstructorUsedError;
  set priceChange(double value) => throw _privateConstructorUsedError;
  double get percentChange => throw _privateConstructorUsedError;
  set percentChange(double value) => throw _privateConstructorUsedError;
  double? get floor => throw _privateConstructorUsedError;
  set floor(double? value) => throw _privateConstructorUsedError;
  double? get ceiling => throw _privateConstructorUsedError;
  set ceiling(double? value) => throw _privateConstructorUsedError;
  double? get totalVolume => throw _privateConstructorUsedError;
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      String ticker,
      double currentPrice,
      double priceChange,
      double percentChange,
      double? floor,
      double? ceiling,
      double? totalVolume,
      double? totalValue,
      double? open,
      double? close,
      double? high,
      double? low});
}

/// @nodoc
class _$StockModelCopyWithImpl<$Res, $Val extends StockModel>
    implements $StockModelCopyWith<$Res> {
  _$StockModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? ticker = null,
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
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ticker: null == ticker
          ? _value.ticker
          : ticker // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
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
      String ticker,
      double currentPrice,
      double priceChange,
      double percentChange,
      double? floor,
      double? ceiling,
      double? totalVolume,
      double? totalValue,
      double? open,
      double? close,
      double? high,
      double? low});
}

/// @nodoc
class __$$StockModelImplCopyWithImpl<$Res>
    extends _$StockModelCopyWithImpl<$Res, _$StockModelImpl>
    implements _$$StockModelImplCopyWith<$Res> {
  __$$StockModelImplCopyWithImpl(
      _$StockModelImpl _value, $Res Function(_$StockModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? ticker = null,
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
  }) {
    return _then(_$StockModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ticker: null == ticker
          ? _value.ticker
          : ticker // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockModelImpl extends _StockModel with DiagnosticableTreeMixin {
  _$StockModelImpl(
      {required this.name,
      required this.ticker,
      required this.currentPrice,
      required this.priceChange,
      required this.percentChange,
      this.floor,
      this.ceiling,
      this.totalVolume,
      this.totalValue,
      this.open,
      this.close,
      this.high,
      this.low})
      : super._();

  factory _$StockModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockModelImplFromJson(json);

  @override
  final String name;
  @override
  final String ticker;
  @override
  double currentPrice;
  @override
  double priceChange;
  @override
  double percentChange;
  @override
  double? floor;
  @override
  double? ceiling;
  @override
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StockModel(name: $name, ticker: $ticker, currentPrice: $currentPrice, priceChange: $priceChange, percentChange: $percentChange, floor: $floor, ceiling: $ceiling, totalVolume: $totalVolume, totalValue: $totalValue, open: $open, close: $close, high: $high, low: $low)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StockModel'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('ticker', ticker))
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
      ..add(DiagnosticsProperty('low', low));
  }

  @JsonKey(ignore: true)
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
      {required final String name,
      required final String ticker,
      required double currentPrice,
      required double priceChange,
      required double percentChange,
      double? floor,
      double? ceiling,
      double? totalVolume,
      double? totalValue,
      double? open,
      double? close,
      double? high,
      double? low}) = _$StockModelImpl;
  _StockModel._() : super._();

  factory _StockModel.fromJson(Map<String, dynamic> json) =
      _$StockModelImpl.fromJson;

  @override
  String get name;
  @override
  String get ticker;
  @override
  double get currentPrice;
  set currentPrice(double value);
  @override
  double get priceChange;
  set priceChange(double value);
  @override
  double get percentChange;
  set percentChange(double value);
  @override
  double? get floor;
  set floor(double? value);
  @override
  double? get ceiling;
  set ceiling(double? value);
  @override
  double? get totalVolume;
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
  @JsonKey(ignore: true)
  _$$StockModelImplCopyWith<_$StockModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
