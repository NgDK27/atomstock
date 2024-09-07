import 'package:flutter/material.dart';
import 'package:oppenhomies/domain/models/stock/stock_change_enum.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';

class StockPointChangeText extends StatelessWidget {
  final double value;
  final StockChange? changeOverride;

  const StockPointChangeText({super.key, required this.value, this.changeOverride});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.formatAsPointChange(),
      style: OpTextStyle.labelMedium(context)
          .spacedOut()
          .colorStockChanges(context, value, changeOverride: changeOverride),
    );
  }
}
