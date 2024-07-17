import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/pages/market/stock_details/screens/stock_details_overview.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/fonts.dart';
import 'package:oppenhomies/styles/fonts.dart';
import 'package:oppenhomies/styles/fonts.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';

enum DetailsTabDestinations { overview, automations, ai }

Map<DetailsTabDestinations, String> skyColors =
    <DetailsTabDestinations, String>{
  DetailsTabDestinations.overview: 'Overview',
  DetailsTabDestinations.automations: 'Automations',
  DetailsTabDestinations.ai: 'Ai',
};

class StockDetails extends HookConsumerWidget {
  const StockDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoAnimation = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );

    final tabController = useTabController(initialLength: 3);

    final stock = StockModel.detailedSample();
    Color accentColor =
        StockColoring.determineStockColor(context, stock.priceChange);
    ColorScheme accentColorScheme = ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness:
            WidgetsBinding.instance.platformDispatcher.platformBrightness);

    return PlatformScaffold(
      material: (_, __) =>
          MaterialScaffoldData(backgroundColor: accentColorScheme.surface),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: OpGradient.pageGradient(
                context,
                center: Alignment.topRight,
                beginColor: accentColor,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              //region Top app bar
              PlatformWidget(
                material: (_, __) => SliverAppBar(
                  title: Text(stock.ticker),
                  centerTitle: true,
                  pinned: true,
                  backgroundColor: accentColorScheme.surface,
                  automaticallyImplyLeading: true,
                  bottom: TabBar(
                    indicatorColor: accentColorScheme.primary,
                    labelColor: accentColorScheme.primary,
                    controller: tabController,
                    tabs: [
                      Tab(
                        text: 'Overview',
                      ),
                      Tab(
                        text: 'Insights',
                      ),
                      Tab(text: 'Automation'),
                    ],
                  ),
                ),
                cupertino: (_, __) => SliverLayoutBuilder(
                  builder:
                      (BuildContext context, SliverConstraints constraints) {
                    final double expandedHeight =
                        MediaQuery.of(context).padding.top +
                            kBottomNavigationBarHeight;

                    final bool isCollapsed = constraints.scrollOffset >=
                        expandedHeight - kBottomNavigationBarHeight;

                    if (isCollapsed) {
                      cupertinoAnimation.forward();
                    } else {
                      cupertinoAnimation.reverse();
                    }

                    return AnimatedBuilder(
                      animation: cupertinoAnimation,
                      builder: (context, child) {
                        return CupertinoSliverNavigationBar(
                          largeTitle: Text(""),
                          alwaysShowMiddle: true,
                          middle: Text(stock.ticker),
                          border: Border(
                            bottom: BorderSide(
                              color: Color.lerp(
                                Colors.transparent,
                                CupertinoColors.separator.withOpacity(0.2),
                                cupertinoAnimation.value,
                              )!,
                            ),
                          ),
                          backgroundColor: Color.lerp(
                            Colors.transparent,
                            OpDynamicColor.surface(context),
                            cupertinoAnimation.value,
                          )!,
                          stretch: true,
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: OpSpacing.xs,
                          ),
                          automaticallyImplyLeading: true,
                        );
                      },
                    );
                  },
                ),
              ),

              // endregion
              // PlatformWidget(
              //   material: (_, __) => TabBarView(
              //     children: [
              //       StockDetailsOverview(stock: stock),
              //       Placeholder(),
              //       Placeholder(),
              //     ],
              //   ),
              // ),
              SliverToBoxAdapter(
                child: PlatformWidget(
                  cupertino: (_, __) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: OpSpacing.md,
                      vertical: OpSpacing.sm,
                    ),
                    child: CupertinoSlidingSegmentedControl(
                      onValueChanged: (value) {},
                      children: <DetailsTabDestinations, Widget>{
                        DetailsTabDestinations.overview: Text(
                          DetailsTabDestinations.overview.name.sentenceCase(),
                          style: OpTextStyle.labelMediumProminent(context)?.copyWith(color: OpDynamicColor.onSurface(context)),
                        ),
                        DetailsTabDestinations.automations: Text(
                          DetailsTabDestinations.automations.name
                              .sentenceCase(),
                          style: OpTextStyle.labelMediumProminent(context)?.copyWith(color: OpDynamicColor.onSurface(context)),
                        ),
                        DetailsTabDestinations.ai: Text(
                          DetailsTabDestinations.ai.name.toUpperCase(),
                          style: OpTextStyle.labelMediumProminent(context)?.copyWith(color: OpDynamicColor.onSurface(context)),
                        ),
                      },
                    ),
                  ),
                ),
              ),
              StockDetailsOverview(stock: stock),
            ],
          ),
        ],
      ),
    );
  }
}
