import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/providers/stock/stock_market_indexes_provider.dart';
import 'package:oppenhomies/domain/providers/stock/stock_market_provider.dart';
import 'package:oppenhomies/pages/home/layouts/stock_market_category_layout.dart';

class Indexes extends HookConsumerWidget {
  const Indexes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexes = ref.watch(stockMarketIndexesProvider);

    return StockMarketCategoryLayout(
      title: "Indexes",
      asyncData: indexes,
      isIndexes: true,
    );
  }
}
