import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';

part 'stock_market_indexes_model.freezed.dart';
part 'stock_market_indexes_model.g.dart';

@freezed
class StockMarketIndexesModel with _$StockMarketIndexesModel {
  factory StockMarketIndexesModel({
    required List<IndexModel> indexes,
  }) = _StockMarketIndexesModel;

  factory StockMarketIndexesModel.fromJson(Map<String, dynamic> json) =>
      _$StockMarketIndexesModelFromJson(json);
}