import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';

part 'stock_market_stocks_model.freezed.dart';
// part 'stock_market_stocks_model.g.dart';

@freezed
class StockMarketStocksModel with _$StockMarketStocksModel {
  factory StockMarketStocksModel({
    required List<StockModel> stocks,
  }) = _StockMarketStocksModel;

  factory StockMarketStocksModel.fromJson(Map<String, dynamic> json) {
    final stocksList = json.values.first as List<dynamic>;
    final stocks = stocksList.map((stockJson) => StockModel.fromJson(stockJson)).toList();
    return StockMarketStocksModel(stocks: stocks);
  }
}