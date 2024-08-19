// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockModelImpl _$$StockModelImplFromJson(Map<String, dynamic> json) =>
    _$StockModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      priceChange: (json['priceChange'] as num).toDouble(),
      percentChange: (json['percentChange'] as num).toDouble(),
      floor: (json['floor'] as num?)?.toDouble(),
      ceiling: (json['ceiling'] as num?)?.toDouble(),
      totalVolume: (json['totalVolume'] as num?)?.toDouble(),
      totalValue: (json['totalValue'] as num?)?.toDouble(),
      open: (json['open'] as num?)?.toDouble(),
      close: (json['close'] as num?)?.toDouble(),
      high: (json['high'] as num?)?.toDouble(),
      low: (json['low'] as num?)?.toDouble(),
      exchange: json['exchange'] == null
          ? null
          : ExchangeModel.fromJson(json['exchange'] as Map<String, dynamic>),
      pricePoints: json['pricePoints'] == null
          ? null
          : StockPricePoints.fromJson(
              json['pricePoints'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StockModelImplToJson(_$StockModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'currentPrice': instance.currentPrice,
      'priceChange': instance.priceChange,
      'percentChange': instance.percentChange,
      'floor': instance.floor,
      'ceiling': instance.ceiling,
      'totalVolume': instance.totalVolume,
      'totalValue': instance.totalValue,
      'open': instance.open,
      'close': instance.close,
      'high': instance.high,
      'low': instance.low,
      'exchange': instance.exchange,
      'pricePoints': instance.pricePoints,
    };
