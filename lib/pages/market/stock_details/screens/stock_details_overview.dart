import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/calculateStockPriceChange.dart';
import 'package:oppenhomies/domain/models/stock/market_session.dart';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';
import 'package:oppenhomies/domain/providers/stock/details/stock_details_provider.dart';
import 'package:oppenhomies/styles/colors.dart';
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

    final marketSession = useState(MarketSession.closed);

    const dateFilterOptions = StockPriceDateFilter.values;

    return data.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        error: (_, __) => const Text("Failed to load data"),
        loading: () => Center(
              child: SizedBox(
                width: OpSpacing.md,
                height: OpSpacing.md,
                child: PlatformCircularProgressIndicator(),
              ),
            ),
        data: (stock) {
          // Get detail fields
          final detailFields = data.value!.detailFields.entries.toList();
          final split = (detailFields.length / 2).ceil();

          // Get accent color
          final accentColor = stock.pricePoints!.points.isNotEmpty
              ? StockColoring.determineStockColor(
                  context,
                  stock.pricePoints!.points.last.price -
                      stock.pricePoints!.points.first.price,
                )
              : OpDynamicColor.primary(context);

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
                    begin: OpDynamicColor.surface(context), end: accentColor),
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
                        Text(
                          switch (type) {
                            StockItemType.idx => stock.currentPrice.toString(),
                            StockItemType.stock =>
                              stock.currentPrice.vndFormat(),
                          },
                          style: OpTextStyle.display(context).spacedOut(),
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
                            )
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
                              horizontal: OpSpacing.xs3),
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
                                                    timeRange: filter);
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
                          ),
                        ),
                        const SizedBox(
                          width: OpSpacing.lg,
                        ),
                        Expanded(
                          child: _buildHalfColumn(
                            detailFields.sublist(split),
                            context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget _buildHalfColumn(
    List<MapEntry<String, double?>> entries,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in entries) ...[
          SimpleRow(
            label: entry.key,
            value: entry.value,
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
