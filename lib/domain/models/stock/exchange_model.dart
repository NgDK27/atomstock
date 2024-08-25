import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_model.freezed.dart';
part 'exchange_model.g.dart';


@freezed
class ExchangeModel with _$ExchangeModel {
  factory ExchangeModel({
    required final String id,
    required final String symbol,
    required final String name,
  }) = _ExchangeModel;

  const ExchangeModel._();

  factory ExchangeModel.fromJson(Map<String, dynamic> json) => _$ExchangeModelFromJson(json);

  factory ExchangeModel.hose() => ExchangeModel(
    id: 'exchange-hose',
    symbol: "HOSE",
    name: 'Ho Chi Minh Stock Exchange',
  );
}
