import 'package:freezed_annotation/freezed_annotation.dart';

part 'details_update.freezed.dart';
part 'details_update.g.dart';

@freezed
class StockDetailUpdate with _$StockDetailUpdate {
  factory StockDetailUpdate({
    @JsonKey(name: 'Symbol') required String symbol,
    @JsonKey(name: 'Price') required double currentPrice,
    @JsonKey(name: 'Change') required double priceChange,
    @JsonKey(name: 'RatioChange') required double percentChange,
    @JsonKey(name: 'Volume') double? volume,
  }) = _StockDetailUpdate;

  factory StockDetailUpdate.fromJson(Map<String, dynamic> json) =>
      _$StockDetailUpdateFromJson(json);
}

@freezed
class IndexDetailUpdate with _$IndexDetailUpdate {
  factory IndexDetailUpdate({
    @JsonKey(name: 'IndexId') required String indexId,
    @JsonKey(name: 'IndexValue') required double indexValue,
    @JsonKey(name: 'Change') required double change,
    @JsonKey(name: 'RatioChange') required double percentChange,
    @JsonKey(name: 'TotalTrade') int? totalTrade,
    @JsonKey(name: 'TotalQtty') int? totalQtty,
    @JsonKey(name: 'TotalValue') double? totalValue,
  }) = _IndexDetailUpdate;

  factory IndexDetailUpdate.fromJson(Map<String, dynamic> json) =>
      _$IndexDetailUpdateFromJson(json);
}