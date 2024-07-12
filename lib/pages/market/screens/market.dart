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

class Market extends ConsumerWidget {
  const Market({super.key});

  void navigateMarketSearch(BuildContext context) {
    context.goNamed(OpRoutes.search.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleStocks = [
      StockModel.sample(),
      StockModel.positiveSample(),
      StockModel.negativeSample()
    ];

    return OpPlatformSliverScaffold(
      title: "Market",
      transitionBetweenRoutes: false,
      slivers: [
        SliverSafeArea(
          top: false,
          // minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              PlatformWidget(
                cupertino: (_, __) => const SizedBox(height: OpSpacing.sm),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: OpSpacing.md),
                child: PlatformWidget(
                  cupertino: (_, __) => CupertinoSearchTextField(
                    placeholder: "Search",
                    onTap: () => navigateMarketSearch(context),
                  ),
                  material: (_, __) => SearchBar(
                    leading: Padding(
                      padding: EdgeInsets.only(left: OpSpacing.xs),
                      child: Icon(Icons.search),
                    ),
                    hintText: "Search",
                    elevation: WidgetStatePropertyAll(0),
                    onTap: () => navigateMarketSearch(context),
                  ),
                ),
              ),
              const SizedBox(height: OpSpacing.lg),
              OpTitle("Indices"),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(height: OpSpacing.xl),
              OpTitle(
                "Top performers today",
                leading: Text(
                  "↗",
                  style:
                      TextStyle(color: OpDynamicColor.aquaHarmonized(context))
                          .bold(),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(
                height: OpSpacing.xl,
              ),
              OpTitle(
                "Top decliners today",
                leading: Text(
                  "↘",
                  style:
                      TextStyle(color: OpDynamicColor.cherryHarmonized(context))
                          .bold(),
                ),
              ),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
              const SizedBox(height: OpSpacing.xl),
              OpTitle("Top movers today",
                  leading: Text("↔", style: TextStyle().bold())),
              ...sampleStocks.map((stock) => StockListTile(stock: stock)),
            ]),
          ),
        ),
      ],
    );
  }
}
