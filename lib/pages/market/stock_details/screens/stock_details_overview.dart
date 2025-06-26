import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/calculateStockPriceChange.dart';
import 'package:oppenhomies/domain/helpers/determine_stock_change_color.dart';
import 'package:oppenhomies/domain/helpers/market_hours_service.dart';
import 'package:oppenhomies/domain/models/stock/market_session.dart';
import 'package:oppenhomies/domain/models/stock/stock_change_enum.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';
import 'package:oppenhomies/domain/providers/stock/details/stock_details_provider.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/effects.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/neutral/op_neutral_text_button.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpTonalPrimaryButton.dart';
import 'package:oppenhomies/widgets/charts/stock_price_chart.dart';
import 'package:oppenhomies/widgets/chip/chip_base.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';
import 'package:oppenhomies/widgets/tables/simple_row.dart';
import 'package:oppenhomies/widgets/typography/stock_percent_change_text.dart';
import 'package:oppenhomies/widgets/typography/stock_point_change_text.dart';
import 'package:oppenhomies/widgets/typography/stock_price_change_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StockDetailsOverview extends HookConsumerWidget {
  final String identifier;
  final StockItemType type;

  const StockDetailsOverview({
    super.key,
    required this.identifier,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = stockDetailsProvider(identifier, type);
    final data = ref.watch(provider);

    final timeRange = useState(StockPriceDateFilter.oneDay);

    final marketSession = useState(
      MarketHoursService.isMarketOpen()
          ? MarketSession.open
          : MarketSession.closed,
    );

    // Animation controllers for price changes
    final priceAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );

    final tableAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );

    // Previous values to detect changes
    final previousPrice = useRef<double?>(null);
    final previousChange = useRef<StockChange?>(null);
    final previousDetailFields = useRef<Map<String, double?>?>(null);

    // Key for forcing chart updates
    final chartKey = useState(UniqueKey());
    final backgroundKey = useState(UniqueKey());

    const dateFilterOptions = StockPriceDateFilter.values;

    return data.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      error: (_, __) => const Text("Failed to load data"),
      data: (stock) {
        // Determine current change for color animation
        final currentChange = stock.priceChange > 0
            ? StockChange.increase
            : stock.priceChange < 0
            ? StockChange.decrease
            : null;

        // Create color animations
        final priceColorAnimation = useAnimation(
          ColorTween(
            begin: determineStockChangeColor(context: context, change: currentChange),
            end: OpDynamicColor.onSurface(context),
          ).animate(
            CurvedAnimation(
              parent: priceAnimationController,
              curve: Curves.easeInOut,
            ),
          ),
        );

        final tableColorAnimation = useAnimation(
          ColorTween(
            begin: determineStockChangeColor(context: context, change: currentChange),
            end: OpDynamicColor.onSurface(context),
          ).animate(
            CurvedAnimation(
              parent: tableAnimationController,
              curve: Curves.easeInOut,
            ),
          ),
        );

        // Trigger animations on price change (only for 1D view)
        useEffect(() {
          if (timeRange.value == StockPriceDateFilter.oneDay) {
            if (previousPrice.value != null && previousPrice.value != stock.currentPrice) {
              priceAnimationController.forward(from: 0.0);
              // Force chart updates
              chartKey.value = UniqueKey();
            }
            previousPrice.value = stock.currentPrice;
            previousChange.value = currentChange;
          }
          return null;
        }, [stock.currentPrice, currentChange, timeRange.value]);

        // Trigger table animation on detail fields change (only for 1D view)
        useEffect(() {
          if (timeRange.value == StockPriceDateFilter.oneDay) {
            if (previousDetailFields.value != null &&
                previousDetailFields.value.toString() != stock.detailFields.toString()) {
              tableAnimationController.forward(from: 0.0);
            }
            previousDetailFields.value = Map.from(stock.detailFields);
          }
          return null;
        }, [stock.detailFields.toString(), timeRange.value]);

        // Get detail fields
        final detailFields = data.value!.detailFields.entries.toList();
        final split = (detailFields.length / 2).ceil();

        // Get accent color based on current change
        final accentColor = currentChange != null
            ? determineStockChangeColor(context: context, change: currentChange)
            : (stock.pricePoints!.points.isNotEmpty
            ? StockColoring.determineStockColor(
          context,
          stock.pricePoints!.points.last.price -
              stock.pricePoints!.points.first.price,
        )
            : OpDynamicColor.primary(context));

        // Calculate price and percentage changes
        final (calculatedPriceChange, calculatedPercentChange) =
        calculatePriceChanges(
          timeRange.value,
          stock.pricePoints?.points ?? [],
        );

        return Stack(
          children: [
            //region Background Gradient
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                begin: OpDynamicColor.surface(context),
                end: accentColor,
              ),
              duration: const Duration(milliseconds: 250),
              builder: (context, color, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    gradient: OpGradient.pageGradient(
                      context,
                      center: Alignment.topRight,
                      beginColor: color ?? OpDynamicColor.surface(context),
                    ),
                  ),
                );
              },
            ),
            //endregion
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OpSpacing.md,
                    vertical: OpSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      switch (marketSession.value) {
                        MarketSession.open => ChipMediumAqua(
                          text:
                          "${stock.exchange?.symbol} • ${marketSession.value.label}",
                        ),
                        MarketSession.closed => ChipMediumNeutral(
                          text:
                          "${stock.exchange?.symbol} • ${marketSession.value.label}",
                        ),
                      },
                      const SizedBox(height: OpSpacing.sm),
                      Text(
                        "${stock.symbol} ${type == StockItemType.stock ? '• ${stock.name}' : ''}",
                        style: OpTextStyle.titleLarge(context),
                      ),
                      const SizedBox(height: OpSpacing.xs3),
                      // Animated current price
                      AnimatedBuilder(
                        animation: priceAnimationController,
                        builder: (context, child) {
                          return Text(
                            switch (type) {
                              StockItemType.idx => stock.currentPrice.toString(),
                              StockItemType.stock => stock.currentPrice.vndFormat(),
                            },
                            key: ValueKey(stock.currentPrice),
                            style: OpTextStyle.display(context).spacedOut().copyWith(
                              color: timeRange.value == StockPriceDateFilter.oneDay
                                  ? priceColorAnimation
                                  : null,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: OpSpacing.xs2),
                      Row(
                        children: [
                          switch (type) {
                            StockItemType.idx => StockPointChangeText(
                              value: timeRange.value ==
                                  StockPriceDateFilter.oneDay
                                  ? stock.priceChange
                                  : calculatedPriceChange,
                            ),
                            StockItemType.stock => StockPriceChangeText(
                              value: timeRange.value ==
                                  StockPriceDateFilter.oneDay
                                  ? stock.priceChange
                                  : calculatedPriceChange,
                            ),
                          },
                          const SizedBox(width: OpSpacing.sm),
                          StockPercentChangeText(
                            value:
                            timeRange.value == StockPriceDateFilter.oneDay
                                ? stock.percentChange
                                : calculatedPercentChange,
                          ),
                          const SizedBox(width: OpSpacing.sm),
                          Text(
                            timeRange.value.description,
                            style: OpTextStyle.labelMedium(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (stock.pricePoints != null)
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          StockLineChart(
                            key: chartKey.value, // Force rebuild when data changes
                            stockPricePoints: stock.pricePoints!,
                            selectedDateFilter: timeRange.value,
                            accentColor: accentColor,
                            isReloading: data.isReloading,
                            type: type,
                          ),
                          AnimatedOpacity(
                            curve: Curves.easeInOut,
                            opacity: data.isReloading ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Center(
                              child: SizedBox(
                                width: OpSpacing.md,
                                height: OpSpacing.md,
                                child: PlatformCircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: OpSpacing.xs3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: dateFilterOptions
                              .map(
                                (filter) => filter == timeRange.value
                                ? OpTonalPrimaryButton(
                              text: filter.label,
                              onPressed: () {},
                            )
                                : OpNeutralTextButton(
                              text: filter.label,
                              onPressed: () {
                                timeRange.value = filter;
                                ref
                                    .read(provider.notifier)
                                    .updateDetailsWithTimeRange(
                                  timeRange: filter,
                                );
                              },
                              tightPadding: true,
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OpSpacing.md,
                    vertical: OpSpacing.lg,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildHalfColumn(
                          detailFields.sublist(0, split),
                          context,
                          tableColorAnimation,
                          tableAnimationController,
                          timeRange.value == StockPriceDateFilter.oneDay,
                        ),
                      ),
                      const SizedBox(
                        width: OpSpacing.lg,
                      ),
                      Expanded(
                        child: _buildHalfColumn(
                          detailFields.sublist(split),
                          context,
                          tableColorAnimation,
                          tableAnimationController,
                          timeRange.value == StockPriceDateFilter.oneDay,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
      loading: () {
        final sampleStock = StockModel.detailedSample(); // For loading state

        final detailFields = sampleStock.detailFields.entries.toList();
        final split = (detailFields.length / 2).ceil();

        return Skeletonizer(
          effect: opShimmerEffect(context),
          child: Stack(
            children: [
              //endregion
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: OpSpacing.md,
                      vertical: OpSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        switch (marketSession.value) {
                          MarketSession.open => ChipMediumAqua(
                            text:
                            "${sampleStock.exchange?.symbol} • ${marketSession.value.label}",
                          ),
                          MarketSession.closed => ChipMediumNeutral(
                            text:
                            "${sampleStock.exchange?.symbol} • ${marketSession.value.label}",
                          ),
                        },
                        const SizedBox(height: OpSpacing.sm),
                        Text(
                          "${sampleStock.symbol} ${type == StockItemType.stock ? '• ${sampleStock.name}' : ''}",
                          style: OpTextStyle.titleLarge(context),
                        ),
                        const SizedBox(height: OpSpacing.xs3),
                        Text(
                          switch (type) {
                            StockItemType.idx =>
                                sampleStock.currentPrice.toString(),
                            StockItemType.stock =>
                                sampleStock.currentPrice.vndFormat(),
                          },
                          style: OpTextStyle.display(context).spacedOut(),
                        ),
                        const SizedBox(height: OpSpacing.xs2),
                        Row(
                          children: [
                            switch (type) {
                              StockItemType.idx => StockPointChangeText(
                                value: sampleStock.priceChange,
                              ),
                              StockItemType.stock => StockPriceChangeText(
                                value: sampleStock.priceChange,
                              ),
                            },
                            const SizedBox(width: OpSpacing.sm),
                            StockPercentChangeText(
                              value: sampleStock.percentChange,
                            ),
                            const SizedBox(width: OpSpacing.sm),
                            Text(
                              timeRange.value.description,
                              style: OpTextStyle.labelMedium(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (sampleStock.pricePoints != null)
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.25,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  OpSpacing.none,
                                  OpSpacing.xl3,
                                  OpSpacing.none,
                                  OpSpacing.none,
                                ),
                                child: const SizedBox(),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: OpSpacing.xs3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: dateFilterOptions
                                .map(
                                  (filter) => filter == timeRange.value
                                  ? OpTonalPrimaryButton(
                                text: filter.label,
                                onPressed: () {},
                              )
                                  : OpNeutralTextButton(
                                text: filter.label,
                                onPressed: () {
                                  timeRange.value = filter;
                                  ref
                                      .read(provider.notifier)
                                      .updateDetailsWithTimeRange(
                                    timeRange: filter,
                                  );
                                },
                                tightPadding: true,
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: OpSpacing.md,
                      vertical: OpSpacing.lg,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildHalfColumn(
                            detailFields.sublist(0, split),
                            context,
                            null,
                            null,
                            false,
                          ),
                        ),
                        const SizedBox(
                          width: OpSpacing.lg,
                        ),
                        Expanded(
                          child: _buildHalfColumn(
                            detailFields.sublist(split),
                            context,
                            null,
                            null,
                            false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHalfColumn(
      List<MapEntry<String, double?>> entries,
      BuildContext context,
      Color? animationColor,
      AnimationController? animationController,
      bool shouldAnimate,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in entries) ...[
          AnimatedBuilder(
            animation: animationController ?? const AlwaysStoppedAnimation(0.0),
            builder: (context, child) {
              return SimpleRow(
                key: ValueKey('${entry.key}-${entry.value}'),
                label: entry.key,
                value: entry.value,
                valueColor: shouldAnimate ? animationColor : null,
              );
            },
          ),
          if (entry != entries.last)
            Divider(
              color: OpDynamicColor.outlineVariant(context),
            ),
        ],
      ],
    );
  }
}