// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_market_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockMarketModelImpl _$$StockMarketModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StockMarketModelImpl(
      indexes: (json['indexes'] as List<dynamic>)
          .map((e) => IndexModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topIncrease: (json['topIncrease'] as List<dynamic>)
          .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topDecrease: (json['topDecrease'] as List<dynamic>)
          .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topVolume: (json['topVolume'] as List<dynamic>)
          .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StockMarketModelImplToJson(
        _$StockMarketModelImpl instance) =>
    <String, dynamic>{
      'indexes': instance.indexes,
      'topIncrease': instance.topIncrease,
      'topDecrease': instance.topDecrease,
      'topVolume': instance.topVolume,
    };
