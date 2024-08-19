// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_price_points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockPricePointsImpl _$$StockPricePointsImplFromJson(
        Map<String, dynamic> json) =>
    _$StockPricePointsImpl(
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => StockPricePoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$StockPricePointsImplToJson(
        _$StockPricePointsImpl instance) =>
    <String, dynamic>{
      'points': instance.points,
    };
