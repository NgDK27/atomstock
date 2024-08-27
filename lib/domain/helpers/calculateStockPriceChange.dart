import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_point.dart';

(double, double) calculatePriceChanges(StockPriceDateFilter filter, List<StockPricePoint> points) {
  if (filter == StockPriceDateFilter.oneDay || points.length < 2) {
    return (0, 0);
  }
  double startPrice = points.first.price;
  double endPrice = points.last.price;
  double priceChange = endPrice - startPrice;
  double percentChange = (priceChange / startPrice) * 100;
  return (priceChange, percentChange);
}