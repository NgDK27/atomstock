import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'stock_price_point.dart';

part 'stock_price_points.freezed.dart';
part 'stock_price_points.g.dart';

@freezed
class StockPricePoints with _$StockPricePoints {
  const StockPricePoints._();

  const factory StockPricePoints({
    @Default([]) List<StockPricePoint> points,
  }) = _StockPricePoints;

  factory StockPricePoints.fromJson(Map<String, dynamic> json) => _$StockPricePointsFromJson(json);

  // TODO: Query backend for data spots

  double get minPrice => points.isEmpty ? 0 : points.map((p) => p.price).reduce((a, b) => a < b ? a : b);
  double get maxPrice => points.isEmpty ? 0 : points.map((p) => p.price).reduce((a, b) => a > b ? a : b);
  DateTime get startDate => points.isEmpty ? DateTime.now() : points.first.timestamp;
  DateTime get endDate => points.isEmpty ? DateTime.now() : points.last.timestamp;

  factory StockPricePoints.sample() {
    final random = Random();
    final startDate = DateTime(2024, 3, 10);
    final endDate = DateTime(2024, 8, 19);
    const interval = Duration(hours: 24);

    List<StockPricePoint> samplePoints = [];
    DateTime currentDate = startDate;
    double basePrice = 100000;

    while (currentDate.isBefore(endDate)) {
      samplePoints.add(StockPricePoint(
        timestamp: currentDate,
        price: basePrice,
      ));

      // More volatile price movement simulation
      double priceChange = random.nextDouble() * 5000 + 5000; // Random value between 5 and 10
      priceChange *= random.nextBool() ? 1 : -1; // Randomly make it positive or negative
      basePrice += priceChange;

      // Ensure price doesn't go negative
      basePrice = max(basePrice, 1.0);

      currentDate = currentDate.add(interval);
    }

    return StockPricePoints(points: samplePoints);
  }
}