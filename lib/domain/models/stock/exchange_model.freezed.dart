// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExchangeModel _$ExchangeModelFromJson(Map<String, dynamic> json) {
  return _ExchangeModel.fromJson(json);
}

/// @nodoc
mixin _$ExchangeModel {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this ExchangeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeModelCopyWith<ExchangeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeModelCopyWith<$Res> {
  factory $ExchangeModelCopyWith(
          ExchangeModel value, $Res Function(ExchangeModel) then) =
      _$ExchangeModelCopyWithImpl<$Res, ExchangeModel>;
  @useResult
  $Res call({String id, String symbol, String name});
}

/// @nodoc
class _$ExchangeModelCopyWithImpl<$Res, $Val extends ExchangeModel>
    implements $ExchangeModelCopyWith<$Res> {
  _$ExchangeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExchangeModelImplCopyWith<$Res>
    implements $ExchangeModelCopyWith<$Res> {
  factory _$$ExchangeModelImplCopyWith(
          _$ExchangeModelImpl value, $Res Function(_$ExchangeModelImpl) then) =
      __$$ExchangeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String symbol, String name});
}

/// @nodoc
class __$$ExchangeModelImplCopyWithImpl<$Res>
    extends _$ExchangeModelCopyWithImpl<$Res, _$ExchangeModelImpl>
    implements _$$ExchangeModelImplCopyWith<$Res> {
  __$$ExchangeModelImplCopyWithImpl(
      _$ExchangeModelImpl _value, $Res Function(_$ExchangeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
  }) {
    return _then(_$ExchangeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeModelImpl extends _ExchangeModel with DiagnosticableTreeMixin {
  _$ExchangeModelImpl(
      {required this.id, required this.symbol, required this.name})
      : super._();

  factory _$ExchangeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  final String name;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ExchangeModel(id: $id, symbol: $symbol, name: $name)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExchangeModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('symbol', symbol))
      ..add(DiagnosticsProperty('name', name));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, symbol, name);

  /// Create a copy of ExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeModelImplCopyWith<_$ExchangeModelImpl> get copyWith =>
      __$$ExchangeModelImplCopyWithImpl<_$ExchangeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeModelImplToJson(
      this,
    );
  }
}

abstract class _ExchangeModel extends ExchangeModel {
  factory _ExchangeModel(
      {required final String id,
      required final String symbol,
      required final String name}) = _$ExchangeModelImpl;
  _ExchangeModel._() : super._();

  factory _ExchangeModel.fromJson(Map<String, dynamic> json) =
      _$ExchangeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get symbol;
  @override
  String get name;

  /// Create a copy of ExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeModelImplCopyWith<_$ExchangeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
