import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/widgets/list_tiles/market_item_list_tile.dart';
import 'package:oppenhomies/widgets/typography/stock_point_change_text.dart';


class IndexListTile extends HookWidget {
  final IndexModel index;

  const IndexListTile({super.key, required this.index});

  void _navigateToDetails(BuildContext context, String indexId) {
    context.pushNamed(
      OpRoutes.stockDetails.name,
      pathParameters: {'identifier': indexId, 'type': StockItemType.idx.value},
    );
  }

  @override
  Widget build(BuildContext context) {
    return MarketItemListTile(
      symbol: index.indexId,
      name: "",
      currentValue: index.indexValue.toString(),
      priceChange: StockPointChangeText(value: index.priceChange),
      percentChange: index.percentChange,
      onTap: () => _navigateToDetails(context, index.indexId),
      change: index.change,
    );
  }
}
