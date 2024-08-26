import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/list_tiles/index_list_tile.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class StockMarketCategoryLayout extends HookConsumerWidget {
  final String title;
  final AsyncValue asyncData;
  final StockItemType type;

  const StockMarketCategoryLayout(
      {super.key,
      required this.title,
      required this.asyncData,
      required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpPlatformSliverScaffold(
      title: title,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              asyncData.when(
                  data: (data) => Column(
                        children: [
                         ...switch(type) {
                           StockItemType.idx => data.indexes.map((index) => IndexListTile(index: index)),
                           StockItemType.stock => data.stocks.map((stock) => StockListTile(stock: stock)),
                         }
                        ],
                      ),
                  error: (_, __) => const Column(
                        children: [Text("Data failed to load")],
                      ),
                  loading: () => Center(
                        child: SizedBox(
                          width: OpSpacing.md,
                          height: OpSpacing.md,
                          child: PlatformCircularProgressIndicator(),
                        ),
                      ))
            ]),
          ),
        ),
      ],
    );
  }
}
