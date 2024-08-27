import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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

  const MarketItemListTile({
    super.key,
    required this.symbol,
    required this.name,
    required this.currentValue,
    required this.priceChange,
    required this.percentChange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = OpTextStyle.bodyLarge(context);
    final TextStyle subtitleStyle = OpTextStyle.labelMedium(context)
        .regular()
        .copyWith(color: OpDynamicColor.onSurfaceVariant(context));

    return PlatformListTile(
      onTap: onTap,
      title: Text(symbol.toUpperCase(), style: titleStyle),
      subtitle: Text(name, style: subtitleStyle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(currentValue, style: titleStyle.spacedOut()),
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