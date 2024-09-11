// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockPortfolioModelImpl _$$StockPortfolioModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StockPortfolioModelImpl(
      symbol: json['symbol'] as String,
      shares: (json['shares'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      currentPrice: (json['current_price'] as num).toDouble(),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$StockPortfolioModelImplToJson(
        _$StockPortfolioModelImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'shares': instance.shares,
      'price': instance.price,
      'current_price': instance.currentPrice,
      'value': instance.value,
    };
