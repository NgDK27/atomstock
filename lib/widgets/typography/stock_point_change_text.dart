import 'package:flutter/material.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';

class StockPointChangeText extends StatelessWidget {
  final double value;

  const StockPointChangeText({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.formatAsPointChange(),
      style: OpTextStyle.labelMedium(context)
          .spacedOut()
          .colorStockChanges(context, value),
    );
  }
}
