// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_market_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockMarketModel _$StockMarketModelFromJson(Map<String, dynamic> json) {
  return _StockMarketModel.fromJson(json);
}

/// @nodoc
mixin _$StockMarketModel {
  List<IndexModel> get indexes => throw _privateConstructorUsedError;
  List<StockModel> get topIncrease => throw _privateConstructorUsedError;
  List<StockModel> get topDecrease => throw _privateConstructorUsedError;
  List<StockModel> get topVolume => throw _privateConstructorUsedError;

  /// Serializes this StockMarketModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockMarketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMarketModelCopyWith<StockMarketModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMarketModelCopyWith<$Res> {
  factory $StockMarketModelCopyWith(
          StockMarketModel value, $Res Function(StockMarketModel) then) =
      _$StockMarketModelCopyWithImpl<$Res, StockMarketModel>;
  @useResult
  $Res call(
      {List<IndexModel> indexes,
      List<StockModel> topIncrease,
      List<StockModel> topDecrease,
      List<StockModel> topVolume});
}

/// @nodoc
class _$StockMarketModelCopyWithImpl<$Res, $Val extends StockMarketModel>
    implements $StockMarketModelCopyWith<$Res> {
  _$StockMarketModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMarketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexes = null,
    Object? topIncrease = null,
    Object? topDecrease = null,
    Object? topVolume = null,
  }) {
    return _then(_value.copyWith(
      indexes: null == indexes
          ? _value.indexes
          : indexes // ignore: cast_nullable_to_non_nullable
              as List<IndexModel>,
      topIncrease: null == topIncrease
          ? _value.topIncrease
          : topIncrease // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      topDecrease: null == topDecrease
          ? _value.topDecrease
          : topDecrease // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      topVolume: null == topVolume
          ? _value.topVolume
          : topVolume // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockMarketModelImplCopyWith<$Res>
    implements $StockMarketModelCopyWith<$Res> {
  factory _$$StockMarketModelImplCopyWith(_$StockMarketModelImpl value,
          $Res Function(_$StockMarketModelImpl) then) =
      __$$StockMarketModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<IndexModel> indexes,
      List<StockModel> topIncrease,
      List<StockModel> topDecrease,
      List<StockModel> topVolume});
}

/// @nodoc
class __$$StockMarketModelImplCopyWithImpl<$Res>
    extends _$StockMarketModelCopyWithImpl<$Res, _$StockMarketModelImpl>
    implements _$$StockMarketModelImplCopyWith<$Res> {
  __$$StockMarketModelImplCopyWithImpl(_$StockMarketModelImpl _value,
      $Res Function(_$StockMarketModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockMarketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? indexes = null,
    Object? topIncrease = null,
    Object? topDecrease = null,
    Object? topVolume = null,
  }) {
    return _then(_$StockMarketModelImpl(
      indexes: null == indexes
          ? _value._indexes
          : indexes // ignore: cast_nullable_to_non_nullable
              as List<IndexModel>,
      topIncrease: null == topIncrease
          ? _value._topIncrease
          : topIncrease // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      topDecrease: null == topDecrease
          ? _value._topDecrease
          : topDecrease // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      topVolume: null == topVolume
          ? _value._topVolume
          : topVolume // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMarketModelImpl implements _StockMarketModel {
  _$StockMarketModelImpl(
      {required final List<IndexModel> indexes,
      required final List<StockModel> topIncrease,
      required final List<StockModel> topDecrease,
      required final List<StockModel> topVolume})
      : _indexes = indexes,
        _topIncrease = topIncrease,
        _topDecrease = topDecrease,
        _topVolume = topVolume;

  factory _$StockMarketModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMarketModelImplFromJson(json);

  final List<IndexModel> _indexes;
  @override
  List<IndexModel> get indexes {
    if (_indexes is EqualUnmodifiableListView) return _indexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_indexes);
  }

  final List<StockModel> _topIncrease;
  @override
  List<StockModel> get topIncrease {
    if (_topIncrease is EqualUnmodifiableListView) return _topIncrease;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topIncrease);
  }

  final List<StockModel> _topDecrease;
  @override
  List<StockModel> get topDecrease {
    if (_topDecrease is EqualUnmodifiableListView) return _topDecrease;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topDecrease);
  }

  final List<StockModel> _topVolume;
  @override
  List<StockModel> get topVolume {
    if (_topVolume is EqualUnmodifiableListView) return _topVolume;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topVolume);
  }

  @override
  String toString() {
    return 'StockMarketModel(indexes: $indexes, topIncrease: $topIncrease, topDecrease: $topDecrease, topVolume: $topVolume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMarketModelImpl &&
            const DeepCollectionEquality().equals(other._indexes, _indexes) &&
            const DeepCollectionEquality()
                .equals(other._topIncrease, _topIncrease) &&
            const DeepCollectionEquality()
                .equals(other._topDecrease, _topDecrease) &&
            const DeepCollectionEquality()
                .equals(other._topVolume, _topVolume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_indexes),
      const DeepCollectionEquality().hash(_topIncrease),
      const DeepCollectionEquality().hash(_topDecrease),
      const DeepCollectionEquality().hash(_topVolume));

  /// Create a copy of StockMarketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMarketModelImplCopyWith<_$StockMarketModelImpl> get copyWith =>
      __$$StockMarketModelImplCopyWithImpl<_$StockMarketModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMarketModelImplToJson(
      this,
    );
  }
}

abstract class _StockMarketModel implements StockMarketModel {
  factory _StockMarketModel(
      {required final List<IndexModel> indexes,
      required final List<StockModel> topIncrease,
      required final List<StockModel> topDecrease,
      required final List<StockModel> topVolume}) = _$StockMarketModelImpl;

  factory _StockMarketModel.fromJson(Map<String, dynamic> json) =
      _$StockMarketModelImpl.fromJson;

  @override
  List<IndexModel> get indexes;
  @override
  List<StockModel> get topIncrease;
  @override
  List<StockModel> get topDecrease;
  @override
  List<StockModel> get topVolume;

  /// Create a copy of StockMarketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMarketModelImplCopyWith<_$StockMarketModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
