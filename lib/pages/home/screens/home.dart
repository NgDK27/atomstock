import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleStocks = [
      StockModel.sample(),
      StockModel.positiveSample(),
      StockModel.negativeSample(),
    ];

    return OpPlatformSliverScaffold(
      title: "Home",
      transitionBetweenRoutes: false,
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
      slivers: [
        SliverSafeArea(
          top: false,
          // minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              PlatformWidget(
                cupertino: (_, __) => const SizedBox(height: OpSpacing.sm),
              ),
              OpTitleLarge(
                "Indexes",
                onPressed: () {},
                leading: Icon(
                  Symbols.bar_chart_rounded,
                  weight: 800,
                  size: 22,
                  color: OpDynamicColor.onSurface(context),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(height: OpSpacing.xl),
              OpTitleLarge(
                "Top performers today",
                onPressed: () {},
                leading: Icon(
                  Symbols.north_east_rounded,
                  weight: 800,
                  size: 22,
                  color: OpDynamicColor.aquaHarmonized(context),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(
                height: OpSpacing.xl,
              ),
              OpTitleLarge(
                "Top decliners today",
                onPressed: () {},
                leading: Icon(
                  Symbols.south_east_rounded,
                  weight: 800,
                  size: 22,
                  color: OpDynamicColor.cherryHarmonized(context),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(height: OpSpacing.xl),
              OpTitleLarge(
                "Top movers today",
                onPressed: () {},
                leading: Icon(
                  Symbols.swap_horiz_rounded,
                  weight: 800,
                  size: 22,
                  color: OpDynamicColor.onSurface(context),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
            ]),
          ),
        ),
      ],
    );
  }
}
