import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/providers/stock/market/stock_market_top_decliners_provider.dart';
import 'package:oppenhomies/pages/home/layouts/stock_market_category_layout.dart';

class TopDecliners extends HookConsumerWidget {
  const TopDecliners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocks = ref.watch(stockMarketTopDeclinersProvider);

    return StockMarketCategoryLayout(
      title: "Top decliners",
      asyncData: stocks,
      type: StockItemType.stock,
    );
  }
}
