import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';

part 'stock_market_model.freezed.dart';
part 'stock_market_model.g.dart';

@freezed
class StockMarketModel with _$StockMarketModel {
  factory StockMarketModel({
    required List<IndexModel> indexes,
    required List<StockModel> topIncrease,
    required List<StockModel> topDecrease,
    required List<StockModel> topVolume,
  }) = _StockMarketModel;

  factory StockMarketModel.fromJson(Map<String, dynamic> json) =>
      _$StockMarketModelFromJson(json);
}