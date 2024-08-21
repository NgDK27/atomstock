import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/typography/title.dart';

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
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
              //   child: PlatformWidget(
              //     cupertino: (_, __) => CupertinoSearchTextField(
              //       placeholder: "Search",
              //       onTap: () => navigateMarketSearch(context),
              //     ),
              //     material: (_, __) => SearchBar(
              //       leading: const Padding(
              //         padding: EdgeInsets.only(left: OpSpacing.xs),
              //         child: Icon(Icons.search),
              //       ),
              //       hintText: "Search",
              //       elevation: const WidgetStatePropertyAll(0),
              //       onTap: () => navigateMarketSearch(context),
              //     ),
              //   ),
              // ),
              const SizedBox(height: OpSpacing.lg),
              OpTitle("Indexes",
                  trailingText: "Show more", trailingOnPressed: () {}),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(height: OpSpacing.xl2),
              OpTitle(
                "Top performers today",
                trailingText: "Show more",
                trailingOnPressed: () {},
                leading: Text(
                  "↗",
                  style:
                      TextStyle(color: OpDynamicColor.aquaHarmonized(context))
                          .bold(),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(
                height: OpSpacing.xl2,
              ),
              OpTitle(
                "Top decliners today",
                trailingText: "Show more",
                trailingOnPressed: () {},
                leading: Text(
                  "↘",
                  style:
                      TextStyle(color: OpDynamicColor.cherryHarmonized(context))
                          .bold(),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(height: OpSpacing.xl2),
              OpTitle(
                "Top movers today",
                trailingText: "Show more",
                trailingOnPressed: () {},
                leading: Text("↔", style: const TextStyle().bold()),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
            ]),
          ),
        ),
      ],
    );
  }
}
