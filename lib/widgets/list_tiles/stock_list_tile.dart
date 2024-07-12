import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/state/status.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';

class StockListTile extends HookWidget {
  final StockModel stock;
  final Status status;

  const StockListTile(
      {super.key, required this.stock, this.status = const Status.success()});

  void navigateDetails({required BuildContext context}) {
    context.pushNamed(OpRoutes.stockDetails.name);
  }

  String get currencySymbol => '₫';

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = OpTextStyle.bodyLarge(context);
    final TextStyle subtitleStyle = OpTextStyle.labelMedium(context)
        .regular()
        .copyWith(color: OpDynamicColor.onSurfaceVariant(context));
    Color changeColor(BuildContext context, double value) => value.isNegative
        ? OpDynamicColor.cherryHarmonized(context)
        : OpDynamicColor.aquaHarmonized(context);
    String priceChangeSymbol(double price) => price.isNegative ? '-' : '+';
    String percentChangeSymbol(double percent) => percent.isNegative ? '↓' : '↑';

    return PlatformListTile(
      onTap: () => navigateDetails(context: context),
      title: Text(stock.ticker.toUpperCase(), style: titleStyle),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${priceChangeSymbol(stock.priceChange)} ${stock.priceChange.abs().vndFormat()}',
                    style: subtitleStyle
                        .spacedOut()
                        .copyWith(color: changeColor(context, stock.priceChange)),
                  )
                ],
              ),
              const SizedBox(width: OpSpacing.sm),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${percentChangeSymbol(stock.percentChange)} ${stock.percentChange.abs()}%',
                    style: subtitleStyle
                        .spacedOut()
                        .copyWith(color: changeColor(context, stock.percentChange)),
                  )
                ],
              ),
            ],
          )
        ],
      ),
      cupertino: (_, __ ) => CupertinoListTileData(
        padding: EdgeInsets.symmetric(horizontal: OpSpacing.md, vertical: OpSpacing.md)
      ),
    );
  }
}
