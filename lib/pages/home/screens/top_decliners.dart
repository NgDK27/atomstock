import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/pages/home/layouts/stock_collections_layout.dart';

class TopDecliners extends HookConsumerWidget {
  const TopDecliners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleStocks = [
      StockModel.sample(),
      StockModel.positiveSample(),
      StockModel.negativeSample(),
      StockModel.detailedSample(),
    ];

    return StockCollectionsLayout(
      title: "Top Decliners Today",
      stocks: sampleStocks,
    );
  }
}
