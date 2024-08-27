// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'index_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IndexModel _$IndexModelFromJson(Map<String, dynamic> json) {
  return _IndexModel.fromJson(json);
}

/// @nodoc
mixin _$IndexModel {
  @JsonKey(name: "IndexId")
  String get indexId => throw _privateConstructorUsedError;
  @JsonKey(name: "IndexId")
  set indexId(String value) => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: "IndexValue")
  double get indexValue => throw _privateConstructorUsedError;
  @JsonKey(name: "IndexValue")
  set indexValue(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "Change")
  double get priceChange => throw _privateConstructorUsedError;
  @JsonKey(name: "Change")
  set priceChange(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "RatioChange")
  double get percentChange => throw _privateConstructorUsedError;
  @JsonKey(name: "RatioChange")
  set percentChange(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "TotalTrade")
  double get trade => throw _privateConstructorUsedError;
  @JsonKey(name: "TotalTrade")
  set trade(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "TotalQtty")
  double get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: "TotalQtty")
  set quantity(double value) => throw _privateConstructorUsedError;
  @JsonKey(name: "TotalValue")
  double get totalValue => throw _privateConstructorUsedError;
  @JsonKey(name: "TotalValue")
  set totalValue(double value) => throw _privateConstructorUsedError;
  StockChange? get change => throw _privateConstructorUsedError;
  set change(StockChange? value) => throw _privateConstructorUsedError;

  /// Serializes this IndexModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexModelCopyWith<IndexModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexModelCopyWith<$Res> {
  factory $IndexModelCopyWith(
          IndexModel value, $Res Function(IndexModel) then) =
      _$IndexModelCopyWithImpl<$Res, IndexModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "IndexId") String indexId,
      String name,
      @JsonKey(name: "IndexValue") double indexValue,
      @JsonKey(name: "Change") double priceChange,
      @JsonKey(name: "RatioChange") double percentChange,
      @JsonKey(name: "TotalTrade") double trade,
      @JsonKey(name: "TotalQtty") double quantity,
      @JsonKey(name: "TotalValue") double totalValue,
      StockChange? change});
}

/// @nodoc
class _$IndexModelCopyWithImpl<$Res, $Val extends IndexModel>
    implements $IndexModelCopyWith<$Res> {
  _$IndexModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexId = null,
    Object? name = null,
    Object? indexValue = null,
    Object? priceChange = null,
    Object? percentChange = null,
    Object? trade = null,
    Object? quantity = null,
    Object? totalValue = null,
    Object? change = freezed,
  }) {
    return _then(_value.copyWith(
      indexId: null == indexId
          ? _value.indexId
          : indexId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      indexValue: null == indexValue
          ? _value.indexValue
          : indexValue // ignore: cast_nullable_to_non_nullable
              as double,
      priceChange: null == priceChange
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as double,
      percentChange: null == percentChange
          ? _value.percentChange
          : percentChange // ignore: cast_nullable_to_non_nullable
              as double,
      trade: null == trade
          ? _value.trade
          : trade // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as StockChange?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndexModelImplCopyWith<$Res>
    implements $IndexModelCopyWith<$Res> {
  factory _$$IndexModelImplCopyWith(
          _$IndexModelImpl value, $Res Function(_$IndexModelImpl) then) =
      __$$IndexModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "IndexId") String indexId,
      String name,
      @JsonKey(name: "IndexValue") double indexValue,
      @JsonKey(name: "Change") double priceChange,
      @JsonKey(name: "RatioChange") double percentChange,
      @JsonKey(name: "TotalTrade") double trade,
      @JsonKey(name: "TotalQtty") double quantity,
      @JsonKey(name: "TotalValue") double totalValue,
      StockChange? change});
}

/// @nodoc
class __$$IndexModelImplCopyWithImpl<$Res>
    extends _$IndexModelCopyWithImpl<$Res, _$IndexModelImpl>
    implements _$$IndexModelImplCopyWith<$Res> {
  __$$IndexModelImplCopyWithImpl(
      _$IndexModelImpl _value, $Res Function(_$IndexModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexId = null,
    Object? name = null,
    Object? indexValue = null,
    Object? priceChange = null,
    Object? percentChange = null,
    Object? trade = null,
    Object? quantity = null,
    Object? totalValue = null,
    Object? change = freezed,
  }) {
    return _then(_$IndexModelImpl(
      indexId: null == indexId
          ? _value.indexId
          : indexId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      indexValue: null == indexValue
          ? _value.indexValue
          : indexValue // ignore: cast_nullable_to_non_nullable
              as double,
      priceChange: null == priceChange
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as double,
      percentChange: null == percentChange
          ? _value.percentChange
          : percentChange // ignore: cast_nullable_to_non_nullable
              as double,
      trade: null == trade
          ? _value.trade
          : trade // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as StockChange?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexModelImpl extends _IndexModel with DiagnosticableTreeMixin {
  _$IndexModelImpl(
      {@JsonKey(name: "IndexId") required this.indexId,
      this.name = "Index name",
      @JsonKey(name: "IndexValue") required this.indexValue,
      @JsonKey(name: "Change") required this.priceChange,
      @JsonKey(name: "RatioChange") required this.percentChange,
      @JsonKey(name: "TotalTrade") required this.trade,
      @JsonKey(name: "TotalQtty") required this.quantity,
      @JsonKey(name: "TotalValue") required this.totalValue,
      this.change})
      : super._();

  factory _$IndexModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexModelImplFromJson(json);

  @override
  @JsonKey(name: "IndexId")
  String indexId;
  @override
  @JsonKey()
  String name;
  @override
  @JsonKey(name: "IndexValue")
  double indexValue;
  @override
  @JsonKey(name: "Change")
  double priceChange;
  @override
  @JsonKey(name: "RatioChange")
  double percentChange;
  @override
  @JsonKey(name: "TotalTrade")
  double trade;
  @override
  @JsonKey(name: "TotalQtty")
  double quantity;
  @override
  @JsonKey(name: "TotalValue")
  double totalValue;
  @override
  StockChange? change;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IndexModel(indexId: $indexId, name: $name, indexValue: $indexValue, priceChange: $priceChange, percentChange: $percentChange, trade: $trade, quantity: $quantity, totalValue: $totalValue, change: $change)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'IndexModel'))
      ..add(DiagnosticsProperty('indexId', indexId))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('indexValue', indexValue))
      ..add(DiagnosticsProperty('priceChange', priceChange))
      ..add(DiagnosticsProperty('percentChange', percentChange))
      ..add(DiagnosticsProperty('trade', trade))
      ..add(DiagnosticsProperty('quantity', quantity))
      ..add(DiagnosticsProperty('totalValue', totalValue))
      ..add(DiagnosticsProperty('change', change));
  }

  /// Create a copy of IndexModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexModelImplCopyWith<_$IndexModelImpl> get copyWith =>
      __$$IndexModelImplCopyWithImpl<_$IndexModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexModelImplToJson(
      this,
    );
  }
}

abstract class _IndexModel extends IndexModel {
  factory _IndexModel(
      {@JsonKey(name: "IndexId") required String indexId,
      String name,
      @JsonKey(name: "IndexValue") required double indexValue,
      @JsonKey(name: "Change") required double priceChange,
      @JsonKey(name: "RatioChange") required double percentChange,
      @JsonKey(name: "TotalTrade") required double trade,
      @JsonKey(name: "TotalQtty") required double quantity,
      @JsonKey(name: "TotalValue") required double totalValue,
      StockChange? change}) = _$IndexModelImpl;
  _IndexModel._() : super._();

  factory _IndexModel.fromJson(Map<String, dynamic> json) =
      _$IndexModelImpl.fromJson;

  @override
  @JsonKey(name: "IndexId")
  String get indexId;
  @JsonKey(name: "IndexId")
  set indexId(String value);
  @override
  String get name;
  set name(String value);
  @override
  @JsonKey(name: "IndexValue")
  double get indexValue;
  @JsonKey(name: "IndexValue")
  set indexValue(double value);
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
  @JsonKey(name: "TotalTrade")
  double get trade;
  @JsonKey(name: "TotalTrade")
  set trade(double value);
  @override
  @JsonKey(name: "TotalQtty")
  double get quantity;
  @JsonKey(name: "TotalQtty")
  set quantity(double value);
  @override
  @JsonKey(name: "TotalValue")
  double get totalValue;
  @JsonKey(name: "TotalValue")
  set totalValue(double value);
  @override
  StockChange? get change;
  set change(StockChange? value);

  /// Create a copy of IndexModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexModelImplCopyWith<_$IndexModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
