import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
        error: (_, __) => Text("Failed to load data"),
        loading: () => PlatformCircularProgressIndicator(),
        data: (stock) {
          final detailFields = data.value!.detailFields.entries.toList();
          final split = (detailFields.length / 2).ceil();
          return ListView(
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
                      "${stock.symbol} • ${stock.name}",
                      style: OpTextStyle.titleLarge(context),
                    ),
                    const SizedBox(height: OpSpacing.xs3),
                    Text(
                      switch (type) {
                        StockItemType.idx => stock.currentPrice.toString(),
                        StockItemType.stock => stock.currentPrice.vndFormat(),
                      },
                      style: OpTextStyle.display(context).spacedOut(),
                    ),
                    const SizedBox(height: OpSpacing.xs2),
                    Row(
                      children: [
                        switch (type) {
                          StockItemType.idx => StockPointChangeText(
                              value: stock.priceChange,
                            ),
                          StockItemType.stock => StockPriceChangeText(
                              value: stock.priceChange,
                            ),
                        },
                        const SizedBox(width: OpSpacing.sm),
                        StockPercentChangeText(
                          value: stock.percentChange,
                        ),
                        const SizedBox(width: OpSpacing.sm),
                        Text(
                          StockPriceDateFilter.oneDay.description,
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
                    StockLineChart(
                      stockPricePoints: stock.pricePoints!,
                      selectedDateFilter: timeRange.value,
                      accentColor: StockColoring.determineStockColor(
                          context, stock.priceChange),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: OpSpacing.xs3),
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
