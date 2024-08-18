import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_point.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_points.dart';
import 'package:oppenhomies/pages/funds/layouts/move_funds.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/radius.dart';

import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/neutral/op_neutral_text_button.dart';
import 'package:oppenhomies/widgets/chip/chip_base.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';
import 'package:intl/intl.dart';


class StockLineChart extends StatefulHookWidget {
  // final String title;

  const StockLineChart({
    Key? key,
    // required this.title,
  }) : super(key: key);

  @override
  State<StockLineChart> createState() => _StockLineChartState();
}

class _StockLineChartState extends State<StockLineChart> {
  @override
  Widget build(BuildContext context) {
    final stockPricePoints = useState(StockPricePoints.sample());
    final dateFilterOptions = ["1D", '5D', '1M', '3M', '6M', 'All'];
    final selectedFilter = useState('5D');

    final filteredData = useMemoized(() {
      final now = DateTime.now();
      final filtered = switch (selectedFilter.value) {
        '1D' => stockPricePoints.value.points.where((point) => point.timestamp.isAfter(now.subtract(const Duration(days: 1)))),
        '5D' => stockPricePoints.value.points.where((point) => point.timestamp.isAfter(now.subtract(const Duration(days: 5)))),
        '1M' => stockPricePoints.value.points.where((point) => point.timestamp.isAfter(now.subtract(const Duration(days: 30)))),
        '3M' => stockPricePoints.value.points.where((point) => point.timestamp.isAfter(now.subtract(const Duration(days: 90)))),
        '6M' => stockPricePoints.value.points.where((point) => point.timestamp.isAfter(now.subtract(const Duration(days: 180)))),
        'All' => stockPricePoints.value.points,
        _ => stockPricePoints.value.points,
      };
      return filtered.toList();
    }, [selectedFilter.value, stockPricePoints.value]);

    final hasData = filteredData.isNotEmpty;

    final accentColor = hasData
        ? StockColoring.determineStockColor(
      context,
      filteredData.last.price - filteredData.first.price,
    )
        : Colors.grey; // Default color when no data

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
                ? LineChart(mainData(accentColor, filteredData, selectedFilter.value))
                : const Center(child: Text('No data available for this period')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OpSpacing.xs3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in dateFilterOptions)
                OpNeutralTextButton(
                  text: label,
                  onPressed: () => selectedFilter.value = label,
                  tightPadding: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, String filter) {
    final style = OpTextStyle.labelSmall(context);
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());

    String text;
    if (filter == '1D') {
      text = DateFormat('HH:mm').format(date);
    } else if (filter == '5D' || filter == '1M') {
      text = DateFormat('MMM d').format(date);
    } else {
      text = DateFormat('MMM yyyy').format(date);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: OpSpacing.xl,
      fitInside: SideTitleFitInsideData.fromTitleMeta(
        meta,
        distanceFromEdge: OpSpacing.md,
      ),
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, List<StockPricePoint> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final minPrice = data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxPrice = data.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    final middlePrice = (minPrice + maxPrice) / 2;

    if (value == minPrice || value == maxPrice || value.toStringAsFixed(2) == middlePrice.toStringAsFixed(2)) {
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

  LineChartData mainData(Color accentColor, List<StockPricePoint> data, String filter) {
    if (data.isEmpty) {
      return LineChartData();
    }

    final minX = data.first.timestamp.millisecondsSinceEpoch.toDouble();
    final maxX = data.last.timestamp.millisecondsSinceEpoch.toDouble();
    final minY = data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((e) => e.price).reduce((a, b) => a > b ? a : b);

    final safeInterval = calculateSafeInterval(data, filter);

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: OpSpacing.xl3,
            interval: safeInterval,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta, filter),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta, data),
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
              barData.dotData,
            );
          }).toList();
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data.map((point) => FlSpot(
            point.timestamp.millisecondsSinceEpoch.toDouble(),
            point.price,
          )).toList(),
          isCurved: true,
          curveSmoothness: 0.5,
          color: accentColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: OpGradient.fadeOutGradient(
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
    );
  }

  double calculateSafeInterval(List<StockPricePoint> data, String filter) {
    if (data.length <= 1) return 1;

    final totalDuration = data.last.timestamp.difference(data.first.timestamp);
    final totalMilliseconds = totalDuration.inMilliseconds.toDouble();

    // Aim for 6 labels (which will result in 5-7 labels in most cases)
    const desiredLabels = 6;

    // Calculate the ideal interval
    double idealInterval = totalMilliseconds / desiredLabels;

    // Round the interval to a nice number
    final magnitudes = [1, 5, 10, 15, 30, 60, 120, 180, 240, 360, 720, 1440];
    final minuteInterval = idealInterval / (1000 * 60);
    final roundedMinutes = magnitudes.firstWhere((m) => m >= minuteInterval, orElse: () => 1440);

    return roundedMinutes * 60 * 1000; // Convert back to milliseconds
  }

  String dateTimeToText(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final formatter = DateFormat('MMM d');
    final text = formatter.format(date);
    return text;
  }
}