import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_price_point.freezed.dart';

@freezed
class StockPricePoint with _$StockPricePoint {
  const factory StockPricePoint({
    required DateTime timestamp,
    required double price,
  }) = _StockPricePoint;
}