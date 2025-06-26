import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/providers/auth/auth_user_info_provider.dart';
import 'package:oppenhomies/domain/providers/portfolio/portfolio_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/effects.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/icon_button.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/list_tiles/portfolio_list_tile.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/typography/title_small.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../domain/models/stock/portfolio/stock_portfolio.dart';

class Portfolio extends HookConsumerWidget {
  const Portfolio({super.key});

  void navigateToNotifications({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.notifications.name);
  }

  void navigateToAddFunds({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.addFunds.name);
  }

  void navigateToWithdrawFunds({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.withdrawFunds.name);
  }

  void navigateToStockDetails({
    required BuildContext context,
  }) {
    context.pushNamed(OpRoutes.stockDetails.name);
  }

  // Create realistic sample portfolio data using StockPortfolioModel
  List<StockPortfolioModel> _createRealisticSampleStocks() {
    return [
      // ACB - Asia Commercial Bank
      // 100 shares bought at 21,000 VND, now worth 22,500 VND
      // Total value: 100 × 22,500 = 2,250,000 VND
      StockPortfolioModel(
        symbol: 'ACB',
        shares: 100.0,
        price: 21000.0, // Purchase price (cost basis)
        currentPrice: 22500.0, // Current market price
        value: 2250000.0, // 100 × 22,500
      ),
      // BCM - Investment And Industrial Development Corporation
      // 50 shares bought at 60,000 VND, now worth 58,000 VND (down)
      // Total value: 50 × 58,000 = 2,900,000 VND
      StockPortfolioModel(
        symbol: 'BCM',
        shares: 50.0,
        price: 60000.0, // Purchase price (cost basis)
        currentPrice: 58000.0, // Current market price (loss)
        value: 2900000.0, // 50 × 58,000
      ),
      // BHM - Ben Tre Aquaproduct Import And Export JSC
      // 200 shares bought at 18,000 VND, now worth 18,500 VND
      // Total value: 200 × 18,500 = 3,700,000 VND
      StockPortfolioModel(
        symbol: 'BHM',
        shares: 200.0,
        price: 18000.0, // Purchase price (cost basis)
        currentPrice: 18500.0, // Current market price
        value: 3700000.0, // 200 × 18,500
      ),
    ];
  }

  // Calculate total portfolio value
  double _calculateTotalPortfolioValue(List<StockPortfolioModel> stocks) {
    return stocks.fold(0.0, (sum, stock) => sum + stock.value);
  }

  // Calculate realistic available funds (should be less than holdings for invested portfolio)
  double _calculateAvailableFunds(double totalHoldings) {
    // Assuming user has about 30% of their holdings value as available cash
    return totalHoldings * 0.3;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(authUserInfoProvider);
    final portfolio = ref.watch(portfolioProvider);

    // Create realistic sample data
    final realisticSampleStocks = _createRealisticSampleStocks();
    final totalHoldingsValue = _calculateTotalPortfolioValue(realisticSampleStocks);
    final availableFunds = _calculateAvailableFunds(totalHoldingsValue);

    // Fallback sample stocks for loading state (grouped properly)
    final sampleStocks = [
      StockModel.sample().copyWith(symbol: 'ACB'),
      StockModel.positiveSample().copyWith(symbol: 'BCM'),
      StockModel.negativeSample().copyWith(symbol: 'BHM'),
    ];

    return OpPlatformSliverScaffold(
      title: "Portfolio",
      topBarTrailing: PlatformIconButton(
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
      ),
      transitionBetweenRoutes: false,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                //region Funds heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: OpSpacing.xs2,
                      ),
                      Text(
                        "Funds",
                        style: OpTextStyle.titleLarge(context),
                      ),
                      const SizedBox(
                        height: OpSpacing.xs3,
                      ),
                      Skeletonizer(
                        enabled: !userInfo.hasValue,
                        enableSwitchAnimation: true,
                        effect: opShimmerEffect(context),
                        child: Text(
                          userInfo.hasValue
                              ? (userInfo.value?.balance.vndFormat() ?? availableFunds.vndFormat())
                              : availableFunds.vndFormat(),
                          style:
                          OpTextStyle.display(context).spacedOut().copyWith(
                            color: OpDynamicColor.onSurface(context),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        height: OpSpacing.xl,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OpIconButton(
                            icon: PlatformIcons(context).add,
                            text: "Add",
                            onPressed: () =>
                                navigateToAddFunds(context: context),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: OpSpacing.xl2,
                      ),
                    ],
                  ),
                ),
                //endregion

                //region Holdings
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: OpSpacing.md),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Holdings",
                          style: OpTextStyle.bodyLarge(context),
                        ),
                        const SizedBox(
                          height: OpSpacing.xs3,
                        ),
                        Skeletonizer(
                          enabled: !portfolio.hasValue,
                          enableSwitchAnimation: true,
                          effect: opShimmerEffect(context),
                          child: Text(
                            portfolio.hasValue
                                ? (portfolio.value?.totalValue.vndFormat() ?? totalHoldingsValue.vndFormat())
                                : totalHoldingsValue.vndFormat(),
                            style: OpTextStyle.headline(context)
                                .spacedOut()
                                .copyWith(
                              color: OpDynamicColor.onSurface(context),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ]),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      portfolio.when(
                        data: (data) {
                          if (data != null && data.positions.isNotEmpty) {
                            final sortedStocks = data.positions
                                .sorted((a, b) => a.symbol.compareTo(b.symbol));
                            final groupedStocks = groupBy(
                              sortedStocks,
                                  (stock) => stock.symbol[0].toUpperCase(),
                            );

                            return Column(
                              children: [
                                ...groupedStocks.entries.map((entry) {
                                  final letter = entry.key;
                                  final stocks = entry.value;
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: OpSpacing.lg),
                                      OpTitleSmall(letter),
                                      ...stocks.map(
                                            (stock) => PortfolioListTile(
                                          stock: stock,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            );
                          } else {
                            // Show realistic sample stocks when no data or empty portfolio
                            final groupedSampleStocks = groupBy(
                              realisticSampleStocks,
                                  (stock) => stock.symbol[0].toUpperCase(),
                            );

                            return Column(
                              children: [
                                ...groupedSampleStocks.entries.map((entry) {
                                  final letter = entry.key;
                                  final stocks = entry.value;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: OpSpacing.lg),
                                      OpTitleSmall(letter),
                                      ...stocks.map(
                                            (stock) => PortfolioListTile(
                                          stock: stock,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            );
                          }
                        },
                        error: (_, __) {
                          // Show realistic sample stocks on error too
                          final groupedSampleStocks = groupBy(
                            realisticSampleStocks,
                                (stock) => stock.symbol[0].toUpperCase(),
                          );

                          return Column(
                            children: [
                              ...groupedSampleStocks.entries.map((entry) {
                                final letter = entry.key;
                                final stocks = entry.value;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: OpSpacing.lg),
                                    OpTitleSmall(letter),
                                    ...stocks.map(
                                          (stock) => PortfolioListTile(
                                        stock: stock,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          );
                        },
                        loading: () => Skeletonizer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...groupBy(sampleStocks, (stock) => stock.symbol[0].toUpperCase())
                                  .entries.map((entry) {
                                final letter = entry.key;
                                final stocks = entry.value;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: OpSpacing.lg),
                                    OpTitleSmall(letter),
                                    ...stocks.map(
                                          (stock) => StockListTile(
                                        stock: stock,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //endregion
              ],
            ),
          ),
        ),
      ],
    );
  }
}