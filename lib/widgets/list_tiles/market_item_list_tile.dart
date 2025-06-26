import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/domain/helpers/determine_stock_change_color.dart';
import 'package:oppenhomies/domain/models/stock/stock_change_enum.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/typography/stock_percent_change_text.dart';

class MarketItemListTile extends HookWidget {
  final String symbol;
  final String name;
  final String currentValue;
  final Widget priceChange;
  final double percentChange;
  final VoidCallback onTap;
  final StockChange? change;

  const MarketItemListTile({
    super.key,
    required this.symbol,
    required this.name,
    required this.currentValue,
    required this.priceChange,
    required this.percentChange,
    required this.onTap,
    this.change,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = OpTextStyle.bodyLarge(context);
    final TextStyle subtitleStyle = OpTextStyle.labelMedium(context)
        .regular()
        .copyWith(color: OpDynamicColor.onSurfaceVariant(context));

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );

    final colorAnimation = useAnimation(
      ColorTween(
        begin: determineStockChangeColor(context: context, change: change),
        end: OpDynamicColor.onSurface(context),
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    useEffect(
      () {
        animationController.forward(from: 0.0);
        return null;
      },
      [currentValue, change],
    );

    return PlatformListTile(
      onTap: onTap,
      title: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Text(
            symbol.toUpperCase(),
            key: ValueKey(currentValue),
            style: titleStyle.spacedOut().copyWith(
                  color: colorAnimation,
                ),
          );
        },
      ),
      subtitle: Text(name, style: subtitleStyle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Text(
                currentValue,
                key: ValueKey(currentValue),
                style: titleStyle.spacedOut().copyWith(
                      color: colorAnimation,
                    ),
              );
            },
          ),
          const SizedBox(height: OpSpacing.xs3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              priceChange,
              const SizedBox(width: OpSpacing.sm),
              StockPercentChangeText(value: percentChange),
            ],
          ),
        ],
      ),
      cupertino: (_, __) =>
          CupertinoListTileData(padding: const EdgeInsets.all(OpSpacing.md)),
    );
  }
}