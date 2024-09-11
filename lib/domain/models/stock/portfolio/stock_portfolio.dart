import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_portfolio.freezed.dart';
part 'stock_portfolio.g.dart';

@unfreezed
class StockPortfolioModel with _$StockPortfolioModel {
  factory StockPortfolioModel({
    @JsonKey(name: "symbol") required final String symbol,
    @JsonKey(name: "shares") required double shares,
    @JsonKey(name: "price") required double price,
    @JsonKey(name: "current_price") required double currentPrice,
    @JsonKey(name: "value") required double value,
  }) = _StockPortfolioModel;

  factory StockPortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$StockPortfolioModelFromJson(json);
}
