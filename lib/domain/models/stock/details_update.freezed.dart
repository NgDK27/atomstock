// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'details_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockDetailUpdate _$StockDetailUpdateFromJson(Map<String, dynamic> json) {
  return _StockDetailUpdate.fromJson(json);
}

/// @nodoc
mixin _$StockDetailUpdate {
  @JsonKey(name: 'Symbol')
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'Price')
  double get currentPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'Change')
  double get priceChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'RatioChange')
  double get percentChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'Volume')
  double? get volume => throw _privateConstructorUsedError;

  /// Serializes this StockDetailUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockDetailUpdateCopyWith<StockDetailUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockDetailUpdateCopyWith<$Res> {
  factory $StockDetailUpdateCopyWith(
          StockDetailUpdate value, $Res Function(StockDetailUpdate) then) =
      _$StockDetailUpdateCopyWithImpl<$Res, StockDetailUpdate>;
  @useResult
  $Res call(
      {@JsonKey(name: 'Symbol') String symbol,
      @JsonKey(name: 'Price') double currentPrice,
      @JsonKey(name: 'Change') double priceChange,
      @JsonKey(name: 'RatioChange') double percentChange,
      @JsonKey(name: 'Volume') double? volume});
}

/// @nodoc
class _$StockDetailUpdateCopyWithImpl<$Res, $Val extends StockDetailUpdate>
    implements $StockDetailUpdateCopyWith<$Res> {
  _$StockDetailUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? currentPrice = null,
    Object? priceChange = null,
    Object? percentChange = null,
    Object? volume = freezed,
  }) {
    return _then(_value.copyWith(
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
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockDetailUpdateImplCopyWith<$Res>
    implements $StockDetailUpdateCopyWith<$Res> {
  factory _$$StockDetailUpdateImplCopyWith(_$StockDetailUpdateImpl value,
          $Res Function(_$StockDetailUpdateImpl) then) =
      __$$StockDetailUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Symbol') String symbol,
      @JsonKey(name: 'Price') double currentPrice,
      @JsonKey(name: 'Change') double priceChange,
      @JsonKey(name: 'RatioChange') double percentChange,
      @JsonKey(name: 'Volume') double? volume});
}

/// @nodoc
class __$$StockDetailUpdateImplCopyWithImpl<$Res>
    extends _$StockDetailUpdateCopyWithImpl<$Res, _$StockDetailUpdateImpl>
    implements _$$StockDetailUpdateImplCopyWith<$Res> {
  __$$StockDetailUpdateImplCopyWithImpl(_$StockDetailUpdateImpl _value,
      $Res Function(_$StockDetailUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? currentPrice = null,
    Object? priceChange = null,
    Object? percentChange = null,
    Object? volume = freezed,
  }) {
    return _then(_$StockDetailUpdateImpl(
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
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockDetailUpdateImpl implements _StockDetailUpdate {
  _$StockDetailUpdateImpl(
      {@JsonKey(name: 'Symbol') required this.symbol,
      @JsonKey(name: 'Price') required this.currentPrice,
      @JsonKey(name: 'Change') required this.priceChange,
      @JsonKey(name: 'RatioChange') required this.percentChange,
      @JsonKey(name: 'Volume') this.volume});

  factory _$StockDetailUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockDetailUpdateImplFromJson(json);

  @override
  @JsonKey(name: 'Symbol')
  final String symbol;
  @override
  @JsonKey(name: 'Price')
  final double currentPrice;
  @override
  @JsonKey(name: 'Change')
  final double priceChange;
  @override
  @JsonKey(name: 'RatioChange')
  final double percentChange;
  @override
  @JsonKey(name: 'Volume')
  final double? volume;

  @override
  String toString() {
    return 'StockDetailUpdate(symbol: $symbol, currentPrice: $currentPrice, priceChange: $priceChange, percentChange: $percentChange, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockDetailUpdateImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.priceChange, priceChange) ||
                other.priceChange == priceChange) &&
            (identical(other.percentChange, percentChange) ||
                other.percentChange == percentChange) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, symbol, currentPrice, priceChange, percentChange, volume);

  /// Create a copy of StockDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockDetailUpdateImplCopyWith<_$StockDetailUpdateImpl> get copyWith =>
      __$$StockDetailUpdateImplCopyWithImpl<_$StockDetailUpdateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockDetailUpdateImplToJson(
      this,
    );
  }
}

abstract class _StockDetailUpdate implements StockDetailUpdate {
  factory _StockDetailUpdate(
      {@JsonKey(name: 'Symbol') required final String symbol,
      @JsonKey(name: 'Price') required final double currentPrice,
      @JsonKey(name: 'Change') required final double priceChange,
      @JsonKey(name: 'RatioChange') required final double percentChange,
      @JsonKey(name: 'Volume') final double? volume}) = _$StockDetailUpdateImpl;

  factory _StockDetailUpdate.fromJson(Map<String, dynamic> json) =
      _$StockDetailUpdateImpl.fromJson;

  @override
  @JsonKey(name: 'Symbol')
  String get symbol;
  @override
  @JsonKey(name: 'Price')
  double get currentPrice;
  @override
  @JsonKey(name: 'Change')
  double get priceChange;
  @override
  @JsonKey(name: 'RatioChange')
  double get percentChange;
  @override
  @JsonKey(name: 'Volume')
  double? get volume;

  /// Create a copy of StockDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockDetailUpdateImplCopyWith<_$StockDetailUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndexDetailUpdate _$IndexDetailUpdateFromJson(Map<String, dynamic> json) {
  return _IndexDetailUpdate.fromJson(json);
}

/// @nodoc
mixin _$IndexDetailUpdate {
  @JsonKey(name: 'IndexId')
  String get indexId => throw _privateConstructorUsedError;
  @JsonKey(name: 'IndexValue')
  double get indexValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'Change')
  double get change => throw _privateConstructorUsedError;
  @JsonKey(name: 'RatioChange')
  double get percentChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalTrade')
  int? get totalTrade => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalQtty')
  int? get totalQtty => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalValue')
  double? get totalValue => throw _privateConstructorUsedError;

  /// Serializes this IndexDetailUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexDetailUpdateCopyWith<IndexDetailUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexDetailUpdateCopyWith<$Res> {
  factory $IndexDetailUpdateCopyWith(
          IndexDetailUpdate value, $Res Function(IndexDetailUpdate) then) =
      _$IndexDetailUpdateCopyWithImpl<$Res, IndexDetailUpdate>;
  @useResult
  $Res call(
      {@JsonKey(name: 'IndexId') String indexId,
      @JsonKey(name: 'IndexValue') double indexValue,
      @JsonKey(name: 'Change') double change,
      @JsonKey(name: 'RatioChange') double percentChange,
      @JsonKey(name: 'TotalTrade') int? totalTrade,
      @JsonKey(name: 'TotalQtty') int? totalQtty,
      @JsonKey(name: 'TotalValue') double? totalValue});
}

/// @nodoc
class _$IndexDetailUpdateCopyWithImpl<$Res, $Val extends IndexDetailUpdate>
    implements $IndexDetailUpdateCopyWith<$Res> {
  _$IndexDetailUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexId = null,
    Object? indexValue = null,
    Object? change = null,
    Object? percentChange = null,
    Object? totalTrade = freezed,
    Object? totalQtty = freezed,
    Object? totalValue = freezed,
  }) {
    return _then(_value.copyWith(
      indexId: null == indexId
          ? _value.indexId
          : indexId // ignore: cast_nullable_to_non_nullable
              as String,
      indexValue: null == indexValue
          ? _value.indexValue
          : indexValue // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      percentChange: null == percentChange
          ? _value.percentChange
          : percentChange // ignore: cast_nullable_to_non_nullable
              as double,
      totalTrade: freezed == totalTrade
          ? _value.totalTrade
          : totalTrade // ignore: cast_nullable_to_non_nullable
              as int?,
      totalQtty: freezed == totalQtty
          ? _value.totalQtty
          : totalQtty // ignore: cast_nullable_to_non_nullable
              as int?,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndexDetailUpdateImplCopyWith<$Res>
    implements $IndexDetailUpdateCopyWith<$Res> {
  factory _$$IndexDetailUpdateImplCopyWith(_$IndexDetailUpdateImpl value,
          $Res Function(_$IndexDetailUpdateImpl) then) =
      __$$IndexDetailUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'IndexId') String indexId,
      @JsonKey(name: 'IndexValue') double indexValue,
      @JsonKey(name: 'Change') double change,
      @JsonKey(name: 'RatioChange') double percentChange,
      @JsonKey(name: 'TotalTrade') int? totalTrade,
      @JsonKey(name: 'TotalQtty') int? totalQtty,
      @JsonKey(name: 'TotalValue') double? totalValue});
}

/// @nodoc
class __$$IndexDetailUpdateImplCopyWithImpl<$Res>
    extends _$IndexDetailUpdateCopyWithImpl<$Res, _$IndexDetailUpdateImpl>
    implements _$$IndexDetailUpdateImplCopyWith<$Res> {
  __$$IndexDetailUpdateImplCopyWithImpl(_$IndexDetailUpdateImpl _value,
      $Res Function(_$IndexDetailUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexId = null,
    Object? indexValue = null,
    Object? change = null,
    Object? percentChange = null,
    Object? totalTrade = freezed,
    Object? totalQtty = freezed,
    Object? totalValue = freezed,
  }) {
    return _then(_$IndexDetailUpdateImpl(
      indexId: null == indexId
          ? _value.indexId
          : indexId // ignore: cast_nullable_to_non_nullable
              as String,
      indexValue: null == indexValue
          ? _value.indexValue
          : indexValue // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      percentChange: null == percentChange
          ? _value.percentChange
          : percentChange // ignore: cast_nullable_to_non_nullable
              as double,
      totalTrade: freezed == totalTrade
          ? _value.totalTrade
          : totalTrade // ignore: cast_nullable_to_non_nullable
              as int?,
      totalQtty: freezed == totalQtty
          ? _value.totalQtty
          : totalQtty // ignore: cast_nullable_to_non_nullable
              as int?,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexDetailUpdateImpl implements _IndexDetailUpdate {
  _$IndexDetailUpdateImpl(
      {@JsonKey(name: 'IndexId') required this.indexId,
      @JsonKey(name: 'IndexValue') required this.indexValue,
      @JsonKey(name: 'Change') required this.change,
      @JsonKey(name: 'RatioChange') required this.percentChange,
      @JsonKey(name: 'TotalTrade') this.totalTrade,
      @JsonKey(name: 'TotalQtty') this.totalQtty,
      @JsonKey(name: 'TotalValue') this.totalValue});

  factory _$IndexDetailUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexDetailUpdateImplFromJson(json);

  @override
  @JsonKey(name: 'IndexId')
  final String indexId;
  @override
  @JsonKey(name: 'IndexValue')
  final double indexValue;
  @override
  @JsonKey(name: 'Change')
  final double change;
  @override
  @JsonKey(name: 'RatioChange')
  final double percentChange;
  @override
  @JsonKey(name: 'TotalTrade')
  final int? totalTrade;
  @override
  @JsonKey(name: 'TotalQtty')
  final int? totalQtty;
  @override
  @JsonKey(name: 'TotalValue')
  final double? totalValue;

  @override
  String toString() {
    return 'IndexDetailUpdate(indexId: $indexId, indexValue: $indexValue, change: $change, percentChange: $percentChange, totalTrade: $totalTrade, totalQtty: $totalQtty, totalValue: $totalValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexDetailUpdateImpl &&
            (identical(other.indexId, indexId) || other.indexId == indexId) &&
            (identical(other.indexValue, indexValue) ||
                other.indexValue == indexValue) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.percentChange, percentChange) ||
                other.percentChange == percentChange) &&
            (identical(other.totalTrade, totalTrade) ||
                other.totalTrade == totalTrade) &&
            (identical(other.totalQtty, totalQtty) ||
                other.totalQtty == totalQtty) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, indexId, indexValue, change,
      percentChange, totalTrade, totalQtty, totalValue);

  /// Create a copy of IndexDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexDetailUpdateImplCopyWith<_$IndexDetailUpdateImpl> get copyWith =>
      __$$IndexDetailUpdateImplCopyWithImpl<_$IndexDetailUpdateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexDetailUpdateImplToJson(
      this,
    );
  }
}

abstract class _IndexDetailUpdate implements IndexDetailUpdate {
  factory _IndexDetailUpdate(
          {@JsonKey(name: 'IndexId') required final String indexId,
          @JsonKey(name: 'IndexValue') required final double indexValue,
          @JsonKey(name: 'Change') required final double change,
          @JsonKey(name: 'RatioChange') required final double percentChange,
          @JsonKey(name: 'TotalTrade') final int? totalTrade,
          @JsonKey(name: 'TotalQtty') final int? totalQtty,
          @JsonKey(name: 'TotalValue') final double? totalValue}) =
      _$IndexDetailUpdateImpl;

  factory _IndexDetailUpdate.fromJson(Map<String, dynamic> json) =
      _$IndexDetailUpdateImpl.fromJson;

  @override
  @JsonKey(name: 'IndexId')
  String get indexId;
  @override
  @JsonKey(name: 'IndexValue')
  double get indexValue;
  @override
  @JsonKey(name: 'Change')
  double get change;
  @override
  @JsonKey(name: 'RatioChange')
  double get percentChange;
  @override
  @JsonKey(name: 'TotalTrade')
  int? get totalTrade;
  @override
  @JsonKey(name: 'TotalQtty')
  int? get totalQtty;
  @override
  @JsonKey(name: 'TotalValue')
  double? get totalValue;

  /// Create a copy of IndexDetailUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexDetailUpdateImplCopyWith<_$IndexDetailUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
