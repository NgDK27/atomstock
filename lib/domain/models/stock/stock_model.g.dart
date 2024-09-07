// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockModelImpl _$$StockModelImplFromJson(Map<String, dynamic> json) =>
    _$StockModelImpl(
      name: json['name'] as String? ?? "Stock Name",
      symbol: json['Symbol'] as String,
      currentPrice: (json['Price'] as num).toDouble(),
      priceChange: (json['Change'] as num).toDouble(),
      percentChange: (json['RatioChange'] as num).toDouble(),
      floor: (json['floor'] as num?)?.toDouble(),
      ceiling: (json['ceiling'] as num?)?.toDouble(),
      totalVolume: (json['Volume'] as num?)?.toDouble(),
      totalValue: (json['totalValue'] as num?)?.toDouble(),
      open: (json['open'] as num?)?.toDouble(),
      close: (json['close'] as num?)?.toDouble(),
      high: (json['high'] as num?)?.toDouble(),
      low: (json['low'] as num?)?.toDouble(),
      change: $enumDecodeNullable(_$StockChangeEnumMap, json['change']),
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
      'name': instance.name,
      'Symbol': instance.symbol,
      'Price': instance.currentPrice,
      'Change': instance.priceChange,
      'RatioChange': instance.percentChange,
      'floor': instance.floor,
      'ceiling': instance.ceiling,
      'Volume': instance.totalVolume,
      'totalValue': instance.totalValue,
      'open': instance.open,
      'close': instance.close,
      'high': instance.high,
      'low': instance.low,
      'change': _$StockChangeEnumMap[instance.change],
      'exchange': instance.exchange,
      'pricePoints': instance.pricePoints,
    };

const _$StockChangeEnumMap = {
  StockChange.increase: 'increase',
  StockChange.decrease: 'decrease',
};
