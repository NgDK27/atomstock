import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/list_tiles/market_item_list_tile.dart';
import 'package:oppenhomies/widgets/typography/stock_price_change_text.dart';

class StockListTile extends StatelessWidget {
  final StockModel stock;

  const StockListTile({super.key, required this.stock});

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
    return MarketItemListTile(
      symbol: stock.symbol,
      name: "",
      currentValue: stock.currentPrice.vndFormat(),
      priceChange: StockPriceChangeText(
        value: stock.priceChange,
      ),
      percentChange: stock.percentChange,
      onTap: () => _navigateToDetails(context, stock.symbol),
      change: stock.change,
    );
  }
}
