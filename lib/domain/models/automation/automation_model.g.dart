// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AutomationModelImpl _$$AutomationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutomationModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ticker: json['ticker'] as String,
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
    );

Map<String, dynamic> _$$AutomationModelImplToJson(
        _$AutomationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ticker': instance.ticker,
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
    };
