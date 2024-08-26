import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/providers/stock/stock_market_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/list_tiles/index_list_tile.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/typography/title_large.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  void navigateSettings(
    BuildContext context,
  ) {
    context.pushNamed(OpRoutes.settings.name);
  }

  void navigateToNotifications({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.notifications.name);
  }

  void navigateToIndexes({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.indexes.name);
  }

  void navigateToTopPerformers({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.topPerformers.name);
  }

  void navigateToTopDecliners({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.topDecliners.name);
  }

  void navigateToTopMovers({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.topMovers.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockMarketData = ref.watch(stockMarketProvider);

    return OpPlatformSliverScaffold(
      title: "Home",
      transitionBetweenRoutes: false,
      topBarTrailing: _buildTopBarIcon(context),
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              stockMarketData.when(
                  data: (stockMarket) => Column(
                        children: [
                          _buildIndexList(
                            title: "Indexes",
                            icon: Icon(
                              Symbols.bar_chart_rounded,
                              weight: 800,
                              size: 22,
                              color: OpDynamicColor.onSurface(context),
                            ),
                            onPressed: () =>
                                navigateToIndexes(context: context),
                            indexes: stockMarket.indexes,
                          ),
                          _buildStockList(
                            title: "Top performers today",
                            icon: Icon(
                              Symbols.north_east_rounded,
                              weight: 800,
                              size: 22,
                              color: OpDynamicColor.aquaHarmonized(context),
                            ),
                            onPressed: () =>
                                navigateToTopPerformers(context: context),
                            stocks: stockMarket.topIncrease,
                          ),
                          _buildStockList(
                            title: "Top decliners today",
                            icon: Icon(
                              Symbols.south_east_rounded,
                              weight: 800,
                              size: 22,
                              color: OpDynamicColor.cherryHarmonized(context),
                            ),
                            onPressed: () =>
                                navigateToTopDecliners(context: context),
                            stocks: stockMarket.topDecrease,
                          ),
                          _buildStockList(
                            title: "Top movers today",
                            icon: Icon(
                              Symbols.swap_horiz_rounded,
                              weight: 800,
                              size: 22,
                              color: OpDynamicColor.onSurface(context),
                            ),
                            onPressed: () =>
                                navigateToTopMovers(context: context),
                            stocks: stockMarket.topVolume,
                          )
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

  Widget _buildTopBarIcon(BuildContext context) {
    return PlatformIconButton(
      cupertino: (_, __) => CupertinoIconButtonData(padding: EdgeInsets.zero),
      icon: Icon(
        platformThemeData(
          context,
          material: (_) => Icons.notifications,
          cupertino: (_) => CupertinoIcons.bell_fill,
        ),
        size: platformThemeData(
          context,
          material: (_) => null,
          cupertino: (_) => 24,
        ),
        color: platformThemeData(
          context,
          material: (_) => null,
          cupertino: (_) => OpDynamicColor.onSurface(context),
        ),
      ),
      onPressed: () => navigateToNotifications(context: context),
    );
  }

  Widget _buildIndexList(
      {required String title,
        required Icon icon,
        required VoidCallback onPressed,
        required List<IndexModel> indexes}) {
    return Column(
      children: [
        OpTitleLarge(title, onPressed: onPressed, leading: icon),
        ...indexes.map((index) => IndexListTile(index: index)),
        const SizedBox(
          height: OpSpacing.lg,
        ),
      ],
    );
  }

  Widget _buildStockList(
      {required String title,
      required Icon icon,
      required VoidCallback onPressed,
      required List<StockModel> stocks}) {
    return Column(
      children: [
        OpTitleLarge(title, onPressed: onPressed, leading: icon),
        ...stocks.map((stock) => StockListTile(stock: stock)),
        const SizedBox(
          height: OpSpacing.lg,
        ),
      ],
    );
  }
}
