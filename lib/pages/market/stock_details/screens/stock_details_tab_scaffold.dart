import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/stock_item_type_from_string.dart';
import 'package:oppenhomies/domain/providers/stock/details/stock_details_provider.dart';
import 'package:oppenhomies/pages/market/stock_details/models/stock_details_tab_destinations.dart';
import 'package:oppenhomies/pages/market/stock_details/screens/stock_details_ai.dart';
import 'package:oppenhomies/pages/market/stock_details/screens/stock_details_automation.dart';
import 'package:oppenhomies/pages/market/stock_details/screens/stock_details_overview.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';

class StockDetails extends HookConsumerWidget {
  final String? identifier;
  final String type;

  const StockDetails({super.key, required this.identifier, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Stock data
    final provider = stockDetailsProvider(identifier!, type.toStockItemType()!);
    final stockDataAsync = ref.watch(provider);

    // Coloring based on change
    final Color accentColor = stockDataAsync.when(
        data: (stock) =>
            StockColoring.determineStockColor(context, stock.priceChange),
        error: (_, __) => OpDynamicColor.surface(context),
        loading: () => OpDynamicColor.surface(context));
    final accentColorScheme = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );

    // TABS

    // Android + iOS
    final tabController = useTabController(
      initialLength: DetailsTabDestinations.values.length,
      keys: DetailsTabDestinations.values,
      vsync: useSingleTickerProvider(),
    );

    // iOS
    final cupertinoSelectedTab =
        useState<DetailsTabDestinations?>(DetailsTabDestinations.overview);
    final segmentedControlHeight = useState<double>(0);
    final segmentedControlKey = useMemoized(() => GlobalKey());

    // iOS - Determine Tab (Segmented Controls) height to use as padding
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? renderBox = segmentedControlKey.currentContext
              ?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            segmentedControlHeight.value = renderBox.size.height;
          }
        });
        return null;
      },
      [],
    );

    // iOS - Determine current tab
    useEffect(
      () {
        void listener() {
          final currentIndex = tabController.index;
          final targetIndex = tabController.animation!.value.round();
          if (currentIndex != targetIndex) {
            cupertinoSelectedTab.value =
                DetailsTabDestinations.values[targetIndex];
          }
        }

        tabController.animation!.addListener(listener);
        return () => tabController.animation!.removeListener(listener);
      },
      [tabController],
    );

    // UI
    return PlatformScaffold(
      material: (_, __) =>
          MaterialScaffoldData(backgroundColor: accentColorScheme.surface),
      appBar: PlatformAppBar(
        title: Text(identifier ?? "PROBLEM"),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          backgroundColor: accentColorScheme.surface,
          bottom:
              // region Android Tab
              TabBar(
            indicatorColor: accentColorScheme.primary,
            labelColor: accentColorScheme.primary,
            controller: tabController,
            tabs: DetailsTabDestinations.values
                .map((tab) => Tab(text: tab.label))
                .toList(),
          ),
          // endregion
        ),
      ),
      body: Stack(
        children: [
          //region Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: OpGradient.pageGradient(
                context,
                center: Alignment.topRight,
                beginColor: accentColor,
              ),
            ),
          ),
          //endregion

          //region Body UI
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: isCupertino(context) ? segmentedControlHeight.value : 0,
              ),
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: DetailsTabDestinations.values.map((tab) {
                  switch (tab) {
                    case DetailsTabDestinations.overview:
                      return stockDataAsync.when(
                          data: (data) => StockDetailsOverview(
                                stock: data,
                                accentColor: accentColor,
                                type: type.toStockItemType()!,
                              ),
                          error: (_, __) => const Text("Failed to load data"),
                          loading: () => Center(
                                child: SizedBox(
                                  height: OpSpacing.md,
                                  width: OpSpacing.md,
                                  child: PlatformCircularProgressIndicator(),
                                ),
                              ));
                    case DetailsTabDestinations.automations:
                      return const StockDetailsAutomation();
                    case DetailsTabDestinations.ai:
                      return const StockDetailsAi();
                  }
                }).toList(),
              ),
            ),
          ),
          // endregion

          //region iOS Tab (Segmented Controls)
          PlatformWidget(
            cupertino: (_, __) => SafeArea(
              bottom: false,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    key: segmentedControlKey,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: OpDynamicColor.surface(context).withOpacity(0.9),
                      border: Border(
                        bottom: BorderSide(
                          color: OpDynamicColor.outlineVariant(context),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OpSpacing.md,
                        vertical: OpSpacing.sm,
                      ),
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: cupertinoSelectedTab.value,
                        onValueChanged: (value) {
                          cupertinoSelectedTab.value = value;
                          tabController.index =
                              DetailsTabDestinations.values.indexOf(
                            value ?? DetailsTabDestinations.overview,
                          );
                        },
                        children: {
                          for (final tab in DetailsTabDestinations.values)
                            tab: Text(
                              tab.label,
                              style: OpTextStyle.labelMediumProminent(context)
                                  ?.copyWith(
                                color: OpDynamicColor.onSurface(context),
                              ),
                            ),
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //endregion
        ],
      ),
    );
  }
}
