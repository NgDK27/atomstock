import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';

part 'stock_update.freezed.dart';

@unfreezed
class StockUpdate with _$StockUpdate {
  factory StockUpdate.fullUpdate({
    required List<IndexModel> indexes,
    required List<StockModel> topDecrease,
    required List<StockModel> topIncrease,
    required List<StockModel> topVolume,
  }) = FullStockUpdate;

  factory StockUpdate.indexUpdate({
    required IndexModel data,
  }) = IndexUpdate;

  factory StockUpdate.stockUpdate({
    required StockModel data,
  }) = SingleStockUpdate;

  factory StockUpdate.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('indexes')) {
      return StockUpdate.fullUpdate(
        indexes: (json['indexes'] as List).map((e) => IndexModel.fromJson(e as Map<String, dynamic>)).toList(),
        topDecrease: (json['topDecrease'] as List).map((e) => StockModel.fromJson(e as Map<String, dynamic>)).toList(),
        topIncrease: (json['topIncrease'] as List).map((e) => StockModel.fromJson(e as Map<String, dynamic>)).toList(),
        topVolume: (json['topVolume'] as List).map((e) => StockModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } else if (json['type'] == 'indexUpdate') {
      return StockUpdate.indexUpdate(data: IndexModel.fromJson(json['data'] as Map<String, dynamic>));
    } else if (json['type'] == 'stockUpdate') {
      return StockUpdate.stockUpdate(data: StockModel.fromJson(json['data'] as Map<String, dynamic>));
    }
    throw Exception('Unknown update type: ${json['type']}');
  }
}