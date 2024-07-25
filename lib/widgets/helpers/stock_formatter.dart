import 'package:flutter/material.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';

extension StockFormatter on double {
  String formatAsPriceChange( ) {
    final symbol = isNegative ? '-' : '+';
    return '$symbol ${abs().vndFormat()}';
  }

  String formatAsPercentageChange( ) {
    final symbol = isNegative ? '↓' : '↑';
    return '$symbol ${abs().toStringAsFixed(2)}%';
  }
}

extension StockColor on TextStyle {
  TextStyle colorStockChanges(BuildContext context, double value) {
    return copyWith(
      color: StockColoring.determineStockColor(context, value),
    );
  }
}

class StockColoring {
  static Color determineStockColor(BuildContext context, double value) {
    return value.isNegative
        ? OpDynamicColor.cherryHarmonized(context)
        : OpDynamicColor.aquaHarmonized(context);
  }
}