import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/stock/exchange_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_points.dart';

part 'stock_model.freezed.dart';
part 'stock_model.g.dart';

@unfreezed
class StockModel with _$StockModel {
  factory StockModel({
    @JsonKey(name: 'Symbol') required final String id,
    @JsonKey(name: 'name')required final String name,
    @JsonKey(name: 'Symbol') required final String symbol,
    @JsonKey(name: 'Price') required double currentPrice,
    @JsonKey(name: 'Change') required double priceChange,
    @JsonKey(name: 'RatioChange') required double percentChange,
    double? floor,
    double? ceiling,
    @JsonKey(name: 'Volume') double? totalVolume,
    double? totalValue,
    double? open,
    double? close,
    double? high,
    double? low,
    ExchangeModel? exchange,
    StockPricePoints? pricePoints,
  }) = _StockModel;

  const StockModel._();

  factory StockModel.fromJson(Map<String, dynamic> json) => _$StockModelFromJson(json);

  // factory StockModel.sample() => StockModel(
  //   id: 'stock-001',
  //   name: 'Phở Stock Exchange',
  //   symbol: 'PHO',
  //   currentPrice: 58310000,
  //   priceChange: 24000,
  //   percentChange: 1.93,
  // );

  // factory StockModel.positiveSample() => StockModel(
  //   id: 'stock-002',
  //   name: 'Bánh Mì Bonanza',
  //   symbol: 'BMI',
  //   currentPrice: 458000000,
  //   priceChange: 23000000,
  //   percentChange: 5.28,
  // );

  // factory StockModel.negativeSample() => StockModel(
  //   id: 'stock-003',
  //   name: 'Durian Derivatives',
  //   symbol: 'PUNGENT',
  //   currentPrice: 115000000,
  //   priceChange: -11500000,
  //   percentChange: -9.09,
  // );

  // factory StockModel.detailedSample() => StockModel(
  //   id: 'stock-004',
  //   name: 'Cà Phê Sữa Đá Tech',
  //   symbol: 'CAFE',
  //   currentPrice: 186000,
  //   priceChange: 8000,
  //   percentChange: 4.49,
  //   floor: 170000,
  //   ceiling: 198000,
  //   totalVolume: 3141592,
  //   totalValue: 584336112000,
  //   open: 178000,
  //   close: 186000,
  //   high: 187000,
  //   low: 177000,
  //   exchange: ExchangeModel.hose(),
  //   pricePoints: StockPricePoints.sample(),
  // );

  // Map<String, double?> get detailFields {
  //   return {
  //     'Floor': floor,
  //     'Ceiling': ceiling,
  //     'Total Volume': totalVolume,
  //     'Total Value': totalValue,
  //     'Open': open,
  //     'Close': close,
  //     'High': high,
  //     'Low': low,
  //   };
  // }
  Map<String, double?> get detailFields {
    return {
      'Current Price': currentPrice,
      'Price Change': priceChange,
      'Percent Change': percentChange,
      'Volume': totalVolume,
    };
  }
}