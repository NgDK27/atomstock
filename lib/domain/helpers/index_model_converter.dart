import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';

extension IndexModelConverter on IndexModel {
  StockModel toStockModel() {
    return StockModel(
      name: name,
      symbol: indexId,
      currentPrice: indexValue,
      priceChange: priceChange,
      percentChange: percentChange,
      totalVolume: quantity.toDouble(),
      totalValue: totalValue.toDouble(),
    );
  }
}