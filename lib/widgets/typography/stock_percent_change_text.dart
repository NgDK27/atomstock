import 'package:flutter/material.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';

class StockPercentChangeText extends StatelessWidget {
  final double value;

  const StockPercentChangeText({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.formatAsPercentageChange(),
      style: OpTextStyle.labelMedium(context)
          .spacedOut()
          .colorStockChanges(context, value),
    );
  }
}
