// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortfolioModelImpl _$$PortfolioModelImplFromJson(Map<String, dynamic> json) =>
    _$PortfolioModelImpl(
      totalValue: (json['totalValue'] as num).toDouble(),
      positions: (json['positions'] as List<dynamic>)
          .map((e) => StockPortfolioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PortfolioModelImplToJson(
        _$PortfolioModelImpl instance) =>
    <String, dynamic>{
      'totalValue': instance.totalValue,
      'positions': instance.positions,
    };
