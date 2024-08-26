// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_market_stocks_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StockMarketStocksModel {
  List<StockModel> get stocks => throw _privateConstructorUsedError;

  /// Create a copy of StockMarketStocksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMarketStocksModelCopyWith<StockMarketStocksModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMarketStocksModelCopyWith<$Res> {
  factory $StockMarketStocksModelCopyWith(StockMarketStocksModel value,
          $Res Function(StockMarketStocksModel) then) =
      _$StockMarketStocksModelCopyWithImpl<$Res, StockMarketStocksModel>;
  @useResult
  $Res call({List<StockModel> stocks});
}

/// @nodoc
class _$StockMarketStocksModelCopyWithImpl<$Res,
        $Val extends StockMarketStocksModel>
    implements $StockMarketStocksModelCopyWith<$Res> {
  _$StockMarketStocksModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMarketStocksModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stocks = null,
  }) {
    return _then(_value.copyWith(
      stocks: null == stocks
          ? _value.stocks
          : stocks // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockMarketStocksModelImplCopyWith<$Res>
    implements $StockMarketStocksModelCopyWith<$Res> {
  factory _$$StockMarketStocksModelImplCopyWith(
          _$StockMarketStocksModelImpl value,
          $Res Function(_$StockMarketStocksModelImpl) then) =
      __$$StockMarketStocksModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StockModel> stocks});
}

/// @nodoc
class __$$StockMarketStocksModelImplCopyWithImpl<$Res>
    extends _$StockMarketStocksModelCopyWithImpl<$Res,
        _$StockMarketStocksModelImpl>
    implements _$$StockMarketStocksModelImplCopyWith<$Res> {
  __$$StockMarketStocksModelImplCopyWithImpl(
      _$StockMarketStocksModelImpl _value,
      $Res Function(_$StockMarketStocksModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockMarketStocksModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stocks = null,
  }) {
    return _then(_$StockMarketStocksModelImpl(
      stocks: null == stocks
          ? _value._stocks
          : stocks // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ));
  }
}

/// @nodoc

class _$StockMarketStocksModelImpl implements _StockMarketStocksModel {
  _$StockMarketStocksModelImpl({required final List<StockModel> stocks})
      : _stocks = stocks;

  final List<StockModel> _stocks;
  @override
  List<StockModel> get stocks {
    if (_stocks is EqualUnmodifiableListView) return _stocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stocks);
  }

  @override
  String toString() {
    return 'StockMarketStocksModel(stocks: $stocks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMarketStocksModelImpl &&
            const DeepCollectionEquality().equals(other._stocks, _stocks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_stocks));

  /// Create a copy of StockMarketStocksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMarketStocksModelImplCopyWith<_$StockMarketStocksModelImpl>
      get copyWith => __$$StockMarketStocksModelImplCopyWithImpl<
          _$StockMarketStocksModelImpl>(this, _$identity);
}

abstract class _StockMarketStocksModel implements StockMarketStocksModel {
  factory _StockMarketStocksModel({required final List<StockModel> stocks}) =
      _$StockMarketStocksModelImpl;

  @override
  List<StockModel> get stocks;

  /// Create a copy of StockMarketStocksModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMarketStocksModelImplCopyWith<_$StockMarketStocksModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
