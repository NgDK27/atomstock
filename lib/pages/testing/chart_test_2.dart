import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/neutral/op_neutral_text_button.dart';
import 'package:oppenhomies/widgets/chip/chip_base.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/helpers/stock_formatter.dart';

class StockLineChartPrev extends StatefulHookWidget {
  const StockLineChartPrev({super.key});

  @override
  State<StockLineChartPrev> createState() => _StockLineChartPrevState();
}

class _StockLineChartPrevState extends State<StockLineChartPrev> {
  bool showAvg = false;

  final dateFilterOptions = ["1D", '5D', '1M', '3M', '6M', 'All'];

  @override
  Widget build(BuildContext context) {
    final accentColor = StockColoring.determineStockColor(
        context, StockModel.negativeSample().priceChange);

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.25,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              OpSpacing.none,
              OpSpacing.xl3,
              OpSpacing.none,
              OpSpacing.none,
            ),
            child: LineChart(
              mainData(accentColor),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: OpSpacing.xs3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in dateFilterOptions)
                OpNeutralTextButton(
                  text: label,
                  onPressed: () {},
                  tightPadding: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = OpTextStyle.labelSmall(context);
    Widget text = switch (value.toInt()) {
      0 => Text('Jan', style: style),
    // 1 => Text('Feb', style: style),
      2 => Text('Mar', style: style),
    // 3 => Text('Apr', style: style),
      4 => Text('May', style: style),
    // 5 => Text('Jun', style: style),
      6 => Text('Jul', style: style),
    // 7 => Text('Aug', style: style),
      8 => Text('Sep', style: style),
    // 9 => Text('Oct', style: style),
      10 => Text('Nov', style: style),
    // 11 => Text('Dec', style: style),
      _ => Text('', style: style),
    };

    return SideTitleWidget(
      axisSide: meta.axisSide,
      fitInside: SideTitleFitInsideData.fromTitleMeta(
        meta,
        distanceFromEdge: OpSpacing.md,
      ),
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(right: -OpSpacing.xl3, child: ChipSmall(text: text)),
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  LineChartData mainData(Color accentColor) {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: OpSpacing.xl,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 6,
      lineTouchData: LineTouchData(
        touchSpotThreshold: OpSpacing.xl5,
        handleBuiltInTouches: true,
        getTouchLineStart: (data, index) => 10,
        getTouchLineEnd: (data, index) => 0,
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
                  text: '${touchedSpot.y} ₫\n',
                  style: OpTextStyle.labelLarge(context)
                      .bold()
                      .copyWith(color: OpDynamicColor.surface(context)),
                ),
                TextSpan(
                  text: ' ${touchedSpot.x}',
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
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 6),
            FlSpot(8, 4),
            FlSpot(9.0, 3),
            FlSpot(9.9, 4),
          ],
          isCurved: true,
          curveSmoothness: 0.5,
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
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 4,
            dashArray: [5, 10],
            color: OpDynamicColor.onSurfaceVariant(context),
          ),
        ],
      ),
    );
  }
}