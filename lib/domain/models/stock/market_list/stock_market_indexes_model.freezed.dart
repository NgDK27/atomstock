// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_market_indexes_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockMarketIndexesModel _$StockMarketIndexesModelFromJson(
    Map<String, dynamic> json) {
  return _StockMarketIndexesModel.fromJson(json);
}

/// @nodoc
mixin _$StockMarketIndexesModel {
  List<IndexModel> get indexes => throw _privateConstructorUsedError;

  /// Serializes this StockMarketIndexesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockMarketIndexesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMarketIndexesModelCopyWith<StockMarketIndexesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMarketIndexesModelCopyWith<$Res> {
  factory $StockMarketIndexesModelCopyWith(StockMarketIndexesModel value,
          $Res Function(StockMarketIndexesModel) then) =
      _$StockMarketIndexesModelCopyWithImpl<$Res, StockMarketIndexesModel>;
  @useResult
  $Res call({List<IndexModel> indexes});
}

/// @nodoc
class _$StockMarketIndexesModelCopyWithImpl<$Res,
        $Val extends StockMarketIndexesModel>
    implements $StockMarketIndexesModelCopyWith<$Res> {
  _$StockMarketIndexesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMarketIndexesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexes = null,
  }) {
    return _then(_value.copyWith(
      indexes: null == indexes
          ? _value.indexes
          : indexes // ignore: cast_nullable_to_non_nullable
              as List<IndexModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockMarketIndexesModelImplCopyWith<$Res>
    implements $StockMarketIndexesModelCopyWith<$Res> {
  factory _$$StockMarketIndexesModelImplCopyWith(
          _$StockMarketIndexesModelImpl value,
          $Res Function(_$StockMarketIndexesModelImpl) then) =
      __$$StockMarketIndexesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<IndexModel> indexes});
}

/// @nodoc
class __$$StockMarketIndexesModelImplCopyWithImpl<$Res>
    extends _$StockMarketIndexesModelCopyWithImpl<$Res,
        _$StockMarketIndexesModelImpl>
    implements _$$StockMarketIndexesModelImplCopyWith<$Res> {
  __$$StockMarketIndexesModelImplCopyWithImpl(
      _$StockMarketIndexesModelImpl _value,
      $Res Function(_$StockMarketIndexesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockMarketIndexesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexes = null,
  }) {
    return _then(_$StockMarketIndexesModelImpl(
      indexes: null == indexes
          ? _value._indexes
          : indexes // ignore: cast_nullable_to_non_nullable
              as List<IndexModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMarketIndexesModelImpl implements _StockMarketIndexesModel {
  _$StockMarketIndexesModelImpl({required final List<IndexModel> indexes})
      : _indexes = indexes;

  factory _$StockMarketIndexesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMarketIndexesModelImplFromJson(json);

  final List<IndexModel> _indexes;
  @override
  List<IndexModel> get indexes {
    if (_indexes is EqualUnmodifiableListView) return _indexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_indexes);
  }

  @override
  String toString() {
    return 'StockMarketIndexesModel(indexes: $indexes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMarketIndexesModelImpl &&
            const DeepCollectionEquality().equals(other._indexes, _indexes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_indexes));

  /// Create a copy of StockMarketIndexesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMarketIndexesModelImplCopyWith<_$StockMarketIndexesModelImpl>
      get copyWith => __$$StockMarketIndexesModelImplCopyWithImpl<
          _$StockMarketIndexesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMarketIndexesModelImplToJson(
      this,
    );
  }
}

abstract class _StockMarketIndexesModel implements StockMarketIndexesModel {
  factory _StockMarketIndexesModel({required final List<IndexModel> indexes}) =
      _$StockMarketIndexesModelImpl;

  factory _StockMarketIndexesModel.fromJson(Map<String, dynamic> json) =
      _$StockMarketIndexesModelImpl.fromJson;

  @override
  List<IndexModel> get indexes;

  /// Create a copy of StockMarketIndexesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMarketIndexesModelImplCopyWith<_$StockMarketIndexesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
