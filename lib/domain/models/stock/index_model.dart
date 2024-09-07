import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/stock/stock_change_enum.dart';

part 'index_model.freezed.dart';
part 'index_model.g.dart';

@unfreezed
class IndexModel with _$IndexModel {
  factory IndexModel({
    @JsonKey(name: "IndexId") required String indexId,
    @Default("Index name") String name,
    @JsonKey(name: "IndexValue") required double indexValue,
    @JsonKey(name: "Change") required double priceChange,
    @JsonKey(name: "RatioChange") required double percentChange,
    @JsonKey(name: "TotalTrade") required double trade,
    @JsonKey(name: "TotalQtty") required double quantity,
    @JsonKey(name: "TotalValue") required double totalValue,
    StockChange? change,
  }) = _IndexModel;

  const IndexModel._();

  factory IndexModel.fromJson(Map<String, dynamic> json) =>
      _$IndexModelFromJson(json);

  Map<String, double?> get detailFields {
    return {
      'Total Volume': trade,
      'Total Quantity': quantity,
      'Total Value': totalValue,
    };
  }
}
