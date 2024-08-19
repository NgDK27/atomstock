// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_price_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockPricePointImpl _$$StockPricePointImplFromJson(
        Map<String, dynamic> json) =>
    _$StockPricePointImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$StockPricePointImplToJson(
        _$StockPricePointImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'price': instance.price,
    };
