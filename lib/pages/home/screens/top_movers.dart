import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/providers/stock/market/stock_market_top_movers_provider.dart';
import 'package:oppenhomies/pages/home/layouts/stock_market_category_layout.dart';

class TopMovers extends HookConsumerWidget {
  const TopMovers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocks = ref.watch(stockMarketTopMoversProvider);

    return StockMarketCategoryLayout(
      title: "Top movers",
      asyncData: stocks,
      type: StockItemType.stock,
    );
  }
}
