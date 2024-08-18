import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/pages/testing/chart_test_2.dart';
import 'package:oppenhomies/pages/testing/chart_testing.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';
import 'package:oppenhomies/widgets/tables/simple_row.dart';
import 'package:oppenhomies/widgets/typography/stock_percent_change_text.dart';
import 'package:oppenhomies/widgets/typography/stock_price_change_text.dart';

class StockDetailsOverview extends HookWidget {
  final StockModel stock;

  const StockDetailsOverview({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final detailFields = stock.detailFields.entries.toList();
    final split = (detailFields.length / 2).ceil();
    const mockTimeFrame = 'Yesterday';

    return  ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: OpSpacing.md,
              vertical: OpSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      stock.ticker,
                      style: OpTextStyle.titleLarge(context),
                    ),
                    SizedBox(width: OpSpacing.xs),
                    Text(
                      '•',
                      style: OpTextStyle.titleSmall(context),
                    ),
                    SizedBox(width: OpSpacing.xs),
                    Text(
                      stock.name,
                      style: OpTextStyle.titleLarge(context),
                    ),
                  ],
                ),
                SizedBox(
                  height: OpSpacing.xs3,
                ),
                Text(
                  stock.currentPrice.vndFormat(),
                  style: OpTextStyle.display(context).spacedOut(),
                ),
                SizedBox(
                  height: OpSpacing.xs2,
                ),
                Row(
                  children: [
                    StockPriceChangeText(
                      value: stock.priceChange,
                    ),
                    const SizedBox(width: OpSpacing.sm),
                    StockPercentChangeText(
                      value: stock.percentChange,
                    ),
                    const SizedBox(width: OpSpacing.sm),
                    Text(
                      mockTimeFrame,
                      style: OpTextStyle.labelMedium(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //region Chart placeholder

          StockLineChart(),
          //endregion
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: OpSpacing.md, vertical: OpSpacing.lg,),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHalfColumn(
                    detailFields.sublist(0, split),
                    context,
                  ),
                ),
                SizedBox(
                  width: OpSpacing.lg,
                ),
                Expanded(
                  child: _buildHalfColumn(
                    detailFields.sublist(split),
                    context,
                  ),
                ),
              ],
            ),
          ),
        ],

    );
  }

  Widget _buildHalfColumn(
      List<MapEntry<String, double?>> entries, BuildContext context,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in entries) ...[
          SimpleRow(
            label: entry.key,
            value: entry.value,
          ),
          if (entry != entries.last)
            Divider(
              color: OpDynamicColor.outlineVariant(context),
            ),
        ],
      ],
    );
  }
}
