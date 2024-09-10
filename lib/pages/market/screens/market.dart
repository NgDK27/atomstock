import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/providers/stock/market/stock_explore.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/effects.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Market extends ConsumerWidget {
  const Market({super.key});

  void navigateMarketSearch(BuildContext context) {
    context.goNamed(OpRoutes.search.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<StockMarketStocksModel> allStocks =
        ref.watch(stockExploreProvider);

    return OpPlatformSliverScaffold(
      title: "Explore",
      transitionBetweenRoutes: false,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, idx) {
                if (idx == 0) {
                  return _searchBar(context);
                }

                final stockIndex = idx - 1;
                if (stockIndex >=
                    (allStocks.hasValue
                        ? allStocks.requireValue.stocks.length
                        : 10)) return null;

                return Skeletonizer(
                  effect: opShimmerEffect(context),
                  enableSwitchAnimation: true,
                  enabled: !allStocks.hasValue,
                  child: StockListTile(
                    stock: allStocks.hasValue
                        ? allStocks.requireValue.stocks[stockIndex]
                        : StockModel.sample(),
                  ),
                );
              },
              childCount: (allStocks.hasValue
                      ? allStocks.requireValue.stocks.length
                      : 10) +
                  1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          OpSpacing.md, OpSpacing.none, OpSpacing.md, OpSpacing.md),
      child: PlatformWidget(
        cupertino: (_, __) => CupertinoSearchTextField(
          placeholder: "Search for stocks and indexes",
          onTap: () => navigateMarketSearch(context),
        ),
        material: (_, __) => SearchBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: OpSpacing.xs),
            child: Icon(Icons.search),
          ),
          hintText: "Search for stocks and indexes",
          elevation: const MaterialStatePropertyAll(0),
          onTap: () => navigateMarketSearch(context),
        ),
      ),
    );
  }
}
