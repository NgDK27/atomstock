// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndexModelImpl _$$IndexModelImplFromJson(Map<String, dynamic> json) =>
    _$IndexModelImpl(
      indexId: json['IndexId'] as String,
      name: json['name'] as String? ?? "Index name",
      indexValue: (json['IndexValue'] as num).toDouble(),
      priceChange: (json['Change'] as num).toDouble(),
      percentChange: (json['RatioChange'] as num).toDouble(),
      trade: (json['TotalTrade'] as num).toDouble(),
      quantity: (json['TotalQtty'] as num).toDouble(),
      totalValue: (json['TotalValue'] as num).toDouble(),
    );

Map<String, dynamic> _$$IndexModelImplToJson(_$IndexModelImpl instance) =>
    <String, dynamic>{
      'IndexId': instance.indexId,
      'name': instance.name,
      'IndexValue': instance.indexValue,
      'Change': instance.priceChange,
      'RatioChange': instance.percentChange,
      'TotalTrade': instance.trade,
      'TotalQtty': instance.quantity,
      'TotalValue': instance.totalValue,
    };
