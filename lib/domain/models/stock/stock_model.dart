import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_model.freezed.dart';

@unfreezed
class StockModel with _$StockModel {
  factory StockModel({
    required final String name,
    required final String ticker,
    required double currentPrice,
    required double priceChange,
    required double percentChange,
  }) = _StockModel;

  factory StockModel.sample() => StockModel(
    name: 'Phở Stock Exchange',
    ticker: 'PHO',
    currentPrice: 69420000, // About $3
    priceChange: 24000,
    percentChange: 1.93,
  );

  factory StockModel.positiveSample() => StockModel(
    name: 'Bánh Mì Bonanza',
    ticker: 'BMI',
    currentPrice: 458000000, // About $20
    priceChange: 23000000,
    percentChange: 5.28,
  );

  factory StockModel.negativeSample() => StockModel(
    name: 'Durian Derivatives',
    ticker: 'PUNGENT',
    currentPrice: 115000000, // About $5
    priceChange: -11500000,
    percentChange: -9.09,
  );
}
