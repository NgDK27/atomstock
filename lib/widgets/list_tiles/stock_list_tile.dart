import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/typography/stock_percent_change_text.dart';
import 'package:oppenhomies/widgets/typography/stock_price_change_text.dart';

class StockListTile extends HookWidget {
  final StockModel stock;
  // final Status status;

  const StockListTile({
    super.key,
    required this.stock,
    // this.status = Status,
  });

  void navigateDetails({required BuildContext context}) {
    context.pushNamed(OpRoutes.stockDetails.name);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = OpTextStyle.bodyLarge(context);
    final TextStyle subtitleStyle = OpTextStyle.labelMedium(context)
        .regular()
        .copyWith(color: OpDynamicColor.onSurfaceVariant(context));

    return PlatformListTile(
      onTap: () => navigateDetails(context: context),
      title: Text(stock.symbol.toUpperCase(), style: titleStyle),
      subtitle: Text(stock.name, style: subtitleStyle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(stock.currentPrice.vndFormat(), style: titleStyle.spacedOut()),
          const SizedBox(height: OpSpacing.xs3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StockPriceChangeText(value: stock.priceChange),
              const SizedBox(width: OpSpacing.sm),
              StockPercentChangeText(value: stock.percentChange),
            ],
          ),
        ],
      ),
      cupertino: (_, __) =>
          CupertinoListTileData(padding: const EdgeInsets.all(OpSpacing.md)),
    );
  }
}
