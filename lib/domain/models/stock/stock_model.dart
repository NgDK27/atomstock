import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_model.freezed.dart';
part 'stock_model.g.dart';

@unfreezed
class StockModel with _$StockModel {
  factory StockModel({
    // TODO: Add 'market this stock belongs to'
    required final String id,
    required final String name,
    required final String ticker,
    required double currentPrice,
    required double priceChange,
    required double percentChange,
    double? floor,
    double? ceiling,
    double? totalVolume,
    double? totalValue,
    double? open,
    double? close,
    double? high,
    double? low,
  }) = _StockModel;

  const StockModel._();

  factory StockModel.fromJson(Map<String, dynamic> json) => _$StockModelFromJson(json);

  factory StockModel.sample() => StockModel(
    id: 'stock-001',
    name: 'Phở Stock Exchange',
    ticker: 'PHO',
    currentPrice: 58310000,
    priceChange: 24000,
    percentChange: 1.93,
  );

  factory StockModel.positiveSample() => StockModel(
    id: 'stock-002',
    name: 'Bánh Mì Bonanza',
    ticker: 'BMI',
    currentPrice: 458000000,
    priceChange: 23000000,
    percentChange: 5.28,
  );

  factory StockModel.negativeSample() => StockModel(
    id: 'stock-003',
    name: 'Durian Derivatives',
    ticker: 'PUNGENT',
    currentPrice: 115000000,
    priceChange: -11500000,
    percentChange: -9.09,
  );

  factory StockModel.detailedSample() => StockModel(
    id: 'stock-004',
    name: 'Cà Phê Sữa Đá Tech',
    ticker: 'CAFE',
    currentPrice: 186000,
    priceChange: 8000,
    percentChange: 4.49,
    floor: 170000,
    ceiling: 198000,
    totalVolume: 3141592,
    totalValue: 584336112000,
    open: 178000,
    close: 186000,
    high: 187000,
    low: 177000,
  );

  Map<String, double?> get detailFields {
    return {
      'Floor': floor,
      'Ceiling': ceiling,
      'Total Volume': totalVolume,
      'Total Value': totalValue,
      'Open': open,
      'Close': close,
      'High': high,
      'Low': low,
    };
  }
}