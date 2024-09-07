// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StockUpdate {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<IndexModel> indexes,
            List<StockModel> topDecrease,
            List<StockModel> topIncrease,
            List<StockModel> topVolume)
        fullUpdate,
    required TResult Function(IndexModel data) indexUpdate,
    required TResult Function(StockModel data) stockUpdate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult? Function(IndexModel data)? indexUpdate,
    TResult? Function(StockModel data)? stockUpdate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult Function(IndexModel data)? indexUpdate,
    TResult Function(StockModel data)? stockUpdate,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FullStockUpdate value) fullUpdate,
    required TResult Function(IndexUpdate value) indexUpdate,
    required TResult Function(SingleStockUpdate value) stockUpdate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FullStockUpdate value)? fullUpdate,
    TResult? Function(IndexUpdate value)? indexUpdate,
    TResult? Function(SingleStockUpdate value)? stockUpdate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FullStockUpdate value)? fullUpdate,
    TResult Function(IndexUpdate value)? indexUpdate,
    TResult Function(SingleStockUpdate value)? stockUpdate,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockUpdateCopyWith<$Res> {
  factory $StockUpdateCopyWith(
          StockUpdate value, $Res Function(StockUpdate) then) =
      _$StockUpdateCopyWithImpl<$Res, StockUpdate>;
}

/// @nodoc
class _$StockUpdateCopyWithImpl<$Res, $Val extends StockUpdate>
    implements $StockUpdateCopyWith<$Res> {
  _$StockUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FullStockUpdateImplCopyWith<$Res> {
  factory _$$FullStockUpdateImplCopyWith(_$FullStockUpdateImpl value,
          $Res Function(_$FullStockUpdateImpl) then) =
      __$$FullStockUpdateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<IndexModel> indexes,
      List<StockModel> topDecrease,
      List<StockModel> topIncrease,
      List<StockModel> topVolume});
}

/// @nodoc
class __$$FullStockUpdateImplCopyWithImpl<$Res>
    extends _$StockUpdateCopyWithImpl<$Res, _$FullStockUpdateImpl>
    implements _$$FullStockUpdateImplCopyWith<$Res> {
  __$$FullStockUpdateImplCopyWithImpl(
      _$FullStockUpdateImpl _value, $Res Function(_$FullStockUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexes = null,
    Object? topDecrease = null,
    Object? topIncrease = null,
    Object? topVolume = null,
  }) {
    return _then(_$FullStockUpdateImpl(
      indexes: null == indexes
          ? _value.indexes
          : indexes // ignore: cast_nullable_to_non_nullable
              as List<IndexModel>,
      topDecrease: null == topDecrease
          ? _value.topDecrease
          : topDecrease // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      topIncrease: null == topIncrease
          ? _value.topIncrease
          : topIncrease // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      topVolume: null == topVolume
          ? _value.topVolume
          : topVolume // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ));
  }
}

/// @nodoc

class _$FullStockUpdateImpl implements FullStockUpdate {
  _$FullStockUpdateImpl(
      {required this.indexes,
      required this.topDecrease,
      required this.topIncrease,
      required this.topVolume});

  @override
  List<IndexModel> indexes;
  @override
  List<StockModel> topDecrease;
  @override
  List<StockModel> topIncrease;
  @override
  List<StockModel> topVolume;

  @override
  String toString() {
    return 'StockUpdate.fullUpdate(indexes: $indexes, topDecrease: $topDecrease, topIncrease: $topIncrease, topVolume: $topVolume)';
  }

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FullStockUpdateImplCopyWith<_$FullStockUpdateImpl> get copyWith =>
      __$$FullStockUpdateImplCopyWithImpl<_$FullStockUpdateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<IndexModel> indexes,
            List<StockModel> topDecrease,
            List<StockModel> topIncrease,
            List<StockModel> topVolume)
        fullUpdate,
    required TResult Function(IndexModel data) indexUpdate,
    required TResult Function(StockModel data) stockUpdate,
  }) {
    return fullUpdate(indexes, topDecrease, topIncrease, topVolume);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult? Function(IndexModel data)? indexUpdate,
    TResult? Function(StockModel data)? stockUpdate,
  }) {
    return fullUpdate?.call(indexes, topDecrease, topIncrease, topVolume);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult Function(IndexModel data)? indexUpdate,
    TResult Function(StockModel data)? stockUpdate,
    required TResult orElse(),
  }) {
    if (fullUpdate != null) {
      return fullUpdate(indexes, topDecrease, topIncrease, topVolume);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FullStockUpdate value) fullUpdate,
    required TResult Function(IndexUpdate value) indexUpdate,
    required TResult Function(SingleStockUpdate value) stockUpdate,
  }) {
    return fullUpdate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FullStockUpdate value)? fullUpdate,
    TResult? Function(IndexUpdate value)? indexUpdate,
    TResult? Function(SingleStockUpdate value)? stockUpdate,
  }) {
    return fullUpdate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FullStockUpdate value)? fullUpdate,
    TResult Function(IndexUpdate value)? indexUpdate,
    TResult Function(SingleStockUpdate value)? stockUpdate,
    required TResult orElse(),
  }) {
    if (fullUpdate != null) {
      return fullUpdate(this);
    }
    return orElse();
  }
}

abstract class FullStockUpdate implements StockUpdate {
  factory FullStockUpdate(
      {required List<IndexModel> indexes,
      required List<StockModel> topDecrease,
      required List<StockModel> topIncrease,
      required List<StockModel> topVolume}) = _$FullStockUpdateImpl;

  List<IndexModel> get indexes;
  set indexes(List<IndexModel> value);
  List<StockModel> get topDecrease;
  set topDecrease(List<StockModel> value);
  List<StockModel> get topIncrease;
  set topIncrease(List<StockModel> value);
  List<StockModel> get topVolume;
  set topVolume(List<StockModel> value);

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FullStockUpdateImplCopyWith<_$FullStockUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IndexUpdateImplCopyWith<$Res> {
  factory _$$IndexUpdateImplCopyWith(
          _$IndexUpdateImpl value, $Res Function(_$IndexUpdateImpl) then) =
      __$$IndexUpdateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IndexModel data});

  $IndexModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$IndexUpdateImplCopyWithImpl<$Res>
    extends _$StockUpdateCopyWithImpl<$Res, _$IndexUpdateImpl>
    implements _$$IndexUpdateImplCopyWith<$Res> {
  __$$IndexUpdateImplCopyWithImpl(
      _$IndexUpdateImpl _value, $Res Function(_$IndexUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$IndexUpdateImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as IndexModel,
    ));
  }

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndexModelCopyWith<$Res> get data {
    return $IndexModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$IndexUpdateImpl implements IndexUpdate {
  _$IndexUpdateImpl({required this.data});

  @override
  IndexModel data;

  @override
  String toString() {
    return 'StockUpdate.indexUpdate(data: $data)';
  }

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexUpdateImplCopyWith<_$IndexUpdateImpl> get copyWith =>
      __$$IndexUpdateImplCopyWithImpl<_$IndexUpdateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<IndexModel> indexes,
            List<StockModel> topDecrease,
            List<StockModel> topIncrease,
            List<StockModel> topVolume)
        fullUpdate,
    required TResult Function(IndexModel data) indexUpdate,
    required TResult Function(StockModel data) stockUpdate,
  }) {
    return indexUpdate(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult? Function(IndexModel data)? indexUpdate,
    TResult? Function(StockModel data)? stockUpdate,
  }) {
    return indexUpdate?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult Function(IndexModel data)? indexUpdate,
    TResult Function(StockModel data)? stockUpdate,
    required TResult orElse(),
  }) {
    if (indexUpdate != null) {
      return indexUpdate(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FullStockUpdate value) fullUpdate,
    required TResult Function(IndexUpdate value) indexUpdate,
    required TResult Function(SingleStockUpdate value) stockUpdate,
  }) {
    return indexUpdate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FullStockUpdate value)? fullUpdate,
    TResult? Function(IndexUpdate value)? indexUpdate,
    TResult? Function(SingleStockUpdate value)? stockUpdate,
  }) {
    return indexUpdate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FullStockUpdate value)? fullUpdate,
    TResult Function(IndexUpdate value)? indexUpdate,
    TResult Function(SingleStockUpdate value)? stockUpdate,
    required TResult orElse(),
  }) {
    if (indexUpdate != null) {
      return indexUpdate(this);
    }
    return orElse();
  }
}

abstract class IndexUpdate implements StockUpdate {
  factory IndexUpdate({required IndexModel data}) = _$IndexUpdateImpl;

  IndexModel get data;
  set data(IndexModel value);

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexUpdateImplCopyWith<_$IndexUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SingleStockUpdateImplCopyWith<$Res> {
  factory _$$SingleStockUpdateImplCopyWith(_$SingleStockUpdateImpl value,
          $Res Function(_$SingleStockUpdateImpl) then) =
      __$$SingleStockUpdateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StockModel data});

  $StockModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$SingleStockUpdateImplCopyWithImpl<$Res>
    extends _$StockUpdateCopyWithImpl<$Res, _$SingleStockUpdateImpl>
    implements _$$SingleStockUpdateImplCopyWith<$Res> {
  __$$SingleStockUpdateImplCopyWithImpl(_$SingleStockUpdateImpl _value,
      $Res Function(_$SingleStockUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SingleStockUpdateImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StockModel,
    ));
  }

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockModelCopyWith<$Res> get data {
    return $StockModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$SingleStockUpdateImpl implements SingleStockUpdate {
  _$SingleStockUpdateImpl({required this.data});

  @override
  StockModel data;

  @override
  String toString() {
    return 'StockUpdate.stockUpdate(data: $data)';
  }

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SingleStockUpdateImplCopyWith<_$SingleStockUpdateImpl> get copyWith =>
      __$$SingleStockUpdateImplCopyWithImpl<_$SingleStockUpdateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<IndexModel> indexes,
            List<StockModel> topDecrease,
            List<StockModel> topIncrease,
            List<StockModel> topVolume)
        fullUpdate,
    required TResult Function(IndexModel data) indexUpdate,
    required TResult Function(StockModel data) stockUpdate,
  }) {
    return stockUpdate(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult? Function(IndexModel data)? indexUpdate,
    TResult? Function(StockModel data)? stockUpdate,
  }) {
    return stockUpdate?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<IndexModel> indexes, List<StockModel> topDecrease,
            List<StockModel> topIncrease, List<StockModel> topVolume)?
        fullUpdate,
    TResult Function(IndexModel data)? indexUpdate,
    TResult Function(StockModel data)? stockUpdate,
    required TResult orElse(),
  }) {
    if (stockUpdate != null) {
      return stockUpdate(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FullStockUpdate value) fullUpdate,
    required TResult Function(IndexUpdate value) indexUpdate,
    required TResult Function(SingleStockUpdate value) stockUpdate,
  }) {
    return stockUpdate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FullStockUpdate value)? fullUpdate,
    TResult? Function(IndexUpdate value)? indexUpdate,
    TResult? Function(SingleStockUpdate value)? stockUpdate,
  }) {
    return stockUpdate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FullStockUpdate value)? fullUpdate,
    TResult Function(IndexUpdate value)? indexUpdate,
    TResult Function(SingleStockUpdate value)? stockUpdate,
    required TResult orElse(),
  }) {
    if (stockUpdate != null) {
      return stockUpdate(this);
    }
    return orElse();
  }
}

abstract class SingleStockUpdate implements StockUpdate {
  factory SingleStockUpdate({required StockModel data}) =
      _$SingleStockUpdateImpl;

  StockModel get data;
  set data(StockModel value);

  /// Create a copy of StockUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SingleStockUpdateImplCopyWith<_$SingleStockUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
