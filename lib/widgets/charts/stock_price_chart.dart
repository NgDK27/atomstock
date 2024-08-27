
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_point.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_points.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';

import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/chip/chip_base.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';
import 'package:intl/intl.dart';

class StockLineChart extends StatefulHookWidget {
  final StockPricePoints stockPricePoints;
  final StockPriceDateFilter selectedDateFilter;
  final Color accentColor;

  const StockLineChart({
    super.key,
    required this.stockPricePoints,
    required this.selectedDateFilter,
    required this.accentColor,
  });

  @override
  State<StockLineChart> createState() => _StockLineChartState();
}

class _StockLineChartState extends State<StockLineChart> {
  @override
  Widget build(BuildContext context) {
    // final stockPricePoints = useState(widget.stockPricePoints);
    //
    // final allData = useMemoized(() {
    //   return stockPricePoints.value.points;
    // }, [stockPricePoints.value]);

    final allData = widget.stockPricePoints.points;

    final hasData = allData.isNotEmpty;

    final accentColor = hasData
        ? StockColoring.determineStockColor(
      context,
      allData.last.price - allData.first.price,
    )
        : widget.accentColor; // Default color when no data

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.25,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              OpSpacing.none,
              OpSpacing.xl3,
              OpSpacing.none,
              OpSpacing.none,
            ),
            child: hasData
                ? LineChart(
                curve: Curves.easeInOutQuad,
                duration: const Duration(milliseconds: 300),
                mainData(accentColor, allData, widget.selectedDateFilter),)
                : const Center(
                child: Text('No data available for this period'),),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, StockPriceDateFilter filter) {
    final style = OpTextStyle.labelSmall(context);
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());

    final text = switch (filter) {
      StockPriceDateFilter.oneDay => DateFormat('HH:mm').format(date),
      StockPriceDateFilter.oneWeek || StockPriceDateFilter.oneMonth => DateFormat('MMM d').format(date),
      _ => DateFormat('MMM yyyy').format(date),
    };

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: OpSpacing.xl,
      fitInside: SideTitleFitInsideData.fromTitleMeta(
        meta,
        distanceFromEdge: OpSpacing.lg,
      ),
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(
      double value, TitleMeta meta, List<StockPricePoint> data,) {
    if (data.isEmpty) return const SizedBox.shrink();

    final minPrice = data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxPrice = data.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    final middlePrice = (minPrice + maxPrice) / 2;

    if (value == minPrice ||
        value == maxPrice ||
        value.toStringAsFixed(2) == middlePrice.toStringAsFixed(2)) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: OpSpacing.md,
              child: ChipSmall(text: value.vndFormat()),
            ),
            const SizedBox.shrink(),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  LineChartData mainData(
      Color accentColor, List<StockPricePoint> data, StockPriceDateFilter filter,) {
    if (data.isEmpty) {
      return LineChartData();
    }

    final minX = data.first.timestamp.millisecondsSinceEpoch.toDouble();
    final maxX = data.last.timestamp.millisecondsSinceEpoch.toDouble();
    final minY = data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((e) => e.price).reduce((a, b) => a > b ? a : b);

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 6,
                getTitlesWidget: (_, __) => const SizedBox.shrink(),),),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: OpSpacing.xl3,
            interval: ((minX + maxX) / 2),
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, meta, filter),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: ((minY + maxY) / 2),
            getTitlesWidget: (value, meta) =>
                leftTitleWidgets(value, meta, data),
            reservedSize: 1,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineTouchData: LineTouchData(
        touchSpotThreshold: OpSpacing.xl5,
        handleBuiltInTouches: true,
        getTouchLineStart: (data, index) => maxY,
        getTouchLineEnd: (data, index) => minY,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: OpRadius.xl,
          showOnTopOfTheChartBoxArea: true,
          fitInsideHorizontally: true,
          getTooltipColor: (_) => OpDynamicColor.onSurface(context),
          getTooltipItems: (touchedSpots) => touchedSpots
              .map(
                (LineBarSpot touchedSpot) => LineTooltipItem(
              "",
              OpTextStyle.regular(),
              children: [
                TextSpan(
                  text: '${touchedSpot.y.vndFormat()}\n',
                  style: OpTextStyle.labelLarge(context)
                      .bold()
                      .copyWith(color: OpDynamicColor.surface(context)),
                ),
                TextSpan(
                  text: ' ${dateTimeToText(touchedSpot.x)}',
                  style: OpTextStyle.labelSmall(context)?.copyWith(
                    color: OpDynamicColor.surfaceContainer(context),
                  ),
                ),
              ],
            ),
          )
              .toList(),
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: OpDynamicColor.onSurfaceVariant(context),
                dashArray: [5, 5],
                strokeWidth: 0.5,
              ),
              FlDotData(
                  show: true,
                  getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                      color: OpDynamicColor.onSurface(context),),),
            );
          }).toList();
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data
              .map(
                (point) => FlSpot(
              point.timestamp.millisecondsSinceEpoch.toDouble(),
              point.price,
            ),
          )
              .toList(),
          // isCurved: true,
          // curveSmoothness: 0.,
          color: accentColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              return spot.x == barData.spots.last.x &&
                  spot.y == barData.spots.last.y;
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: OpGradient.fadeOutGradientStrong(
                context,
                beginColor: accentColor,
              ),
              stops: OpGradient.fadeOutStops(),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      extraLinesData: ExtraLinesData(
        extraLinesOnTop: false,
        horizontalLines: [
          HorizontalLine(
            y: data.last.price,
            dashArray: [5, 10],
            color: OpDynamicColor.onSurfaceVariant(context)
                .withOpacity(OpOpacity.quaternary),
          ),
        ],
      ),
    );
  }

  String dateTimeToText(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final formatter = DateFormat('MMM d, h:mm a');
    final text = formatter.format(date);
    return text;
  }
}
