import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/providers/auth/auth_user_info_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/icon_button.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/list_tiles/portfolio_list_tile.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/typography/title.dart';
import 'package:oppenhomies/widgets/typography/title_small.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(authUserInfoProvider);

    // final vndFund = useState<double>(200500000);
    // final totalPortfolioValue = useState<double>(1007000000);

    final sampleStocks = [
      StockModel.sample(),
      StockModel.positiveSample(),
      StockModel.negativeSample(),
      StockModel.detailedSample(),
    ];
    const int mockSharesOwned = 8;

    final sortedStocks =
        sampleStocks.sorted((a, b) => a.symbol.compareTo(b.symbol));
    final groupedStocks = groupBy(
      sortedStocks,
      (StockModel stock) => stock.symbol[0].toUpperCase(),
    );

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
            delegate: SliverChildListDelegate([
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
                      "Total value",
                      style: OpTextStyle.titleLarge(context),
                    ),
                    const SizedBox(
                      height: OpSpacing.xs3,
                    ),
                    Skeletonizer(
                      enabled: !userInfo.hasValue,
                      enableSwitchAnimation: true,
                      containersColor: OpDynamicColor.primaryVariant(context),
                      child: Text(
                        userInfo.hasValue
                            ? userInfo.value!.balance.vndFormat()
                            : "5000",
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
                          onPressed: () => navigateToAddFunds(context: context),
                        ),
                        // OpIconButton(
                        //   icon: PlatformIcons(context).downArrow,
                        //   text: "Withdraw",
                        //   onPressed: () =>
                        //       navigateToWithdrawFunds(context: context),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: OpSpacing.xl2,
                    ),
                  ],
                ),
              ),
              //endregion

              //region Funds
              const OpTitle("Funds"),
              Skeletonizer(
                enabled: !userInfo.hasValue,
                enableSwitchAnimation: true,
                containersColor: OpDynamicColor.primaryVariant(context),
                child: PortfolioListTile(
                  leadingText: "VND",
                  subtitleText: 'Vietnam Dong',
                  topTrailingText: userInfo.hasValue ? userInfo.value!.balance.vndFormat() : "1000",
                  bottomTrailingText: "",
                ),
              ),
              const SizedBox(
                height: OpSpacing.xl,
              ),
              //endregion

              //region Holdings
              const OpTitle("Holdings"),
              // Generate alphabetical sections
              ...groupedStocks.entries.map((entry) {
                final letter = entry.key;
                final stocks = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: OpSpacing.lg),
                    OpTitleSmall(letter),
                    ...stocks.map(
                      (stock) => PortfolioListTile(
                        onPressed: () =>
                            navigateToStockDetails(context: context),
                        leadingText: stock.symbol,
                        subtitleText: stock.name,
                        topTrailingText:
                            (stock.currentPrice * mockSharesOwned).vndFormat(),
                        bottomTrailingText: '$mockSharesOwned shares',
                      ),
                    ),
                  ],
                );
              }),
              //endregion
            ]),
          ),
        ),
      ],
    );
  }
}
