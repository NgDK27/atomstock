import 'package:flutter/material.dart';
import 'package:oppenhomies/domain/helpers/determine_stock_change_color.dart';
import 'package:oppenhomies/domain/models/stock/stock_change_enum.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';

extension StockFormatter on double {
  String formatAsPriceChange({StockChange? changeOverride}) {
    final symbol = changeOverride != null
        ? switch (changeOverride) {
            StockChange.increase => '+',
            StockChange.decrease => '-',
          }
        : isNegative
            ? '-'
            : '+';
    return '$symbol ${abs().vndFormat()}';
  }

  String formatAsPercentageChange({StockChange? changeOverride}) {
    final symbol = changeOverride != null
        ? switch (changeOverride) {
            StockChange.increase => '↑',
            StockChange.decrease => '↓',
          }
        : isNegative
            ? '↓'
            : '↑';
    return '$symbol ${abs().toStringAsFixed(2)}%';
  }

  String formatAsPointChange({StockChange? changeOverride}) {
    final symbol = changeOverride != null
        ? switch (changeOverride) {
            StockChange.increase => '+',
            StockChange.decrease => '-',
          }
        : isNegative
            ? '-'
            : '+';
    return '$symbol ${abs().toStringAsFixed(2)}';
  }
}

extension StockColor on TextStyle {
  TextStyle colorStockChanges(
      BuildContext context, double value, {StockChange? changeOverride,}) {
    return copyWith(
      color: StockColoring.determineStockColor(context, value, changeOverride: changeOverride),
    );
  }
}

class StockColoring {
  static Color determineStockColor(
      BuildContext context, double value, {StockChange? changeOverride,}) {
    if (changeOverride == null) {
      return value.isNegative
          ? OpDynamicColor.cherryHarmonized(context)
          : OpDynamicColor.aquaHarmonized(context);
    } else {
      return determineStockChangeColor(
          context: context, change: changeOverride,);
    }
  }
}
