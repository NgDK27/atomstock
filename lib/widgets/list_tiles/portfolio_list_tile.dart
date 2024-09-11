import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/stock/portfolio/stock_portfolio.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';

class PortfolioListTile extends HookWidget {
  final StockPortfolioModel stock;

  const PortfolioListTile({super.key, required this.stock});

  void _navigateToDetails(BuildContext context, String stockSymbol) {
    context.pushNamed(
      OpRoutes.stockDetails.name,
      pathParameters: {
        'identifier': stockSymbol,
        'type': StockItemType.stock.value,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = OpTextStyle.bodyLarge(context);
    final TextStyle subtitleStyle = OpTextStyle.labelMedium(context)
        .regular()
        .copyWith(color: OpDynamicColor.onSurfaceVariant(context));

    return PlatformListTile(
      key: ValueKey('${stock.symbol}-${stock.currentPrice}'),
      onTap: () => _navigateToDetails(context, stock.symbol),
      title: Text(
        stock.symbol,
        style: titleStyle,
      ),
      subtitle: Text("${stock.shares} shares owned", style: subtitleStyle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stock.value.vndFormat(),
            style: titleStyle.spacedOut(),
          ),
          SizedBox(height: OpSpacing.xs3,),
          Text(
            "${stock.price.vndFormat()} / share",
            style: subtitleStyle.spacedOut(),
          ),
        ],
      ),
      cupertino: (_, __) =>
          CupertinoListTileData(padding: const EdgeInsets.all(OpSpacing.md)),
    );
  }
}
