import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oppenhomies/domain/providers/stock/market/stock_market_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/pages/home/layouts/stock_list.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

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
    final stockMarketAsyncValue = ref.watch(stockMarketProvider);

    return OpPlatformSliverScaffold(
      title: "Home",
      transitionBetweenRoutes: false,
      topBarTrailing: _buildTopBarIcon(context),
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              stockMarketAsyncValue.when(
                data: (stockMarket) => Column(
                  children: [
                    marketIndexList(
                      title: "Indexes",
                      icon: Icon(
                        Symbols.bar_chart_rounded,
                        weight: 800,
                        size: 22,
                        color: OpDynamicColor.onSurface(context),
                      ),
                      onPressed: () => navigateToIndexes(context: context),
                      indexes: stockMarket.indexes,
                    ),
                    marketStockList(
                      title: "Top movers today",
                      icon: Icon(
                        Symbols.swap_horiz_rounded,
                        weight: 800,
                        size: 22,
                        color: OpDynamicColor.onSurface(context),
                      ),
                      onPressed: () => navigateToTopMovers(context: context),
                      stocks: stockMarket.topVolume,
                    ),
                    marketStockList(
                      title: "Top performers today",
                      icon: Icon(
                        Symbols.north_east_rounded,
                        weight: 800,
                        size: 22,
                        color: OpDynamicColor.aquaHarmonized(context),
                      ),
                      onPressed: () => navigateToTopPerformers(context: context),
                      stocks: stockMarket.topIncrease,
                    ),
                    marketStockList(
                      title: "Top decliners today",
                      icon: Icon(
                        Symbols.south_east_rounded,
                        weight: 800,
                        size: 22,
                        color: OpDynamicColor.cherryHarmonized(context),
                      ),
                      onPressed: () => navigateToTopDecliners(context: context),
                      stocks: stockMarket.topDecrease,
                    ),
                  ],
                ),
                error: (error, stack) => Text("Error: $error"),
                loading: () => Center(
                  child: SizedBox(
                    width: OpSpacing.md,
                    height: OpSpacing.md,
                    child: PlatformCircularProgressIndicator(),
                  ),
                ),
              ),
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
}
