// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockDetailUpdateImpl _$$StockDetailUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$StockDetailUpdateImpl(
      symbol: json['Symbol'] as String,
      currentPrice: (json['Price'] as num).toDouble(),
      priceChange: (json['Change'] as num).toDouble(),
      percentChange: (json['RatioChange'] as num).toDouble(),
      volume: (json['Volume'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$StockDetailUpdateImplToJson(
        _$StockDetailUpdateImpl instance) =>
    <String, dynamic>{
      'Symbol': instance.symbol,
      'Price': instance.currentPrice,
      'Change': instance.priceChange,
      'RatioChange': instance.percentChange,
      'Volume': instance.volume,
    };

_$IndexDetailUpdateImpl _$$IndexDetailUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$IndexDetailUpdateImpl(
      indexId: json['IndexId'] as String,
      indexValue: (json['IndexValue'] as num).toDouble(),
      change: (json['Change'] as num).toDouble(),
      percentChange: (json['RatioChange'] as num).toDouble(),
      totalTrade: (json['TotalTrade'] as num?)?.toInt(),
      totalQtty: (json['TotalQtty'] as num?)?.toInt(),
      totalValue: (json['TotalValue'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$IndexDetailUpdateImplToJson(
        _$IndexDetailUpdateImpl instance) =>
    <String, dynamic>{
      'IndexId': instance.indexId,
      'IndexValue': instance.indexValue,
      'Change': instance.change,
      'RatioChange': instance.percentChange,
      'TotalTrade': instance.totalTrade,
      'TotalQtty': instance.totalQtty,
      'TotalValue': instance.totalValue,
    };
