import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/pages/home/layouts/stock_market_category_layout.dart';

class TopMovers extends HookConsumerWidget {
  const TopMovers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final sampleStocks = [
    //   StockModel.sample(),
    //   StockModel.positiveSample(),
    //   StockModel.negativeSample(),
    //   StockModel.detailedSample(),
    // ];
    //
    // return StockMarketCategoryLayout(
    //   title: "Top Movers Today",
    //   stocks: sampleStocks,
    // );
    return Placeholder();

  }
}
