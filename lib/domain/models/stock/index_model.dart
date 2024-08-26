import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    @JsonKey(name: "TotalQtty") required int quantity,
    @JsonKey(name: "TotalValue") required int totalValue,
  }) = _IndexModel;

  factory IndexModel.fromJson(Map<String, dynamic> json) =>
      _$IndexModelFromJson(json);
}
