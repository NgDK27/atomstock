// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_market_indexes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockMarketIndexesModelImpl _$$StockMarketIndexesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StockMarketIndexesModelImpl(
      indexes: (json['indexes'] as List<dynamic>)
          .map((e) => IndexModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StockMarketIndexesModelImplToJson(
        _$StockMarketIndexesModelImpl instance) =>
    <String, dynamic>{
      'indexes': instance.indexes,
    };
