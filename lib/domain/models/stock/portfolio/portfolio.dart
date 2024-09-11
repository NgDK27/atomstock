import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/stock/portfolio/stock_portfolio.dart';

part 'portfolio.freezed.dart';
part 'portfolio.g.dart';

@freezed
class PortfolioModel with _$PortfolioModel {
  factory PortfolioModel({
    @JsonKey(name: 'totalValue') required double totalValue,
    @JsonKey(name: 'positions') required List<StockPortfolioModel> positions,
  }) = _PortfolioModel;

  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);
}