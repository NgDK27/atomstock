import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PortfolioListTile extends HookWidget {
  final String leadingText;
  final String subtitleText;
  final String topTrailingText;
  final String bottomTrailingText;
  final VoidCallback? onPressed;

  const PortfolioListTile({
    super.key,
    required this.leadingText,
    required this.subtitleText,
    required this.topTrailingText,
    required this.bottomTrailingText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = OpTextStyle.bodyLarge(context);
    final TextStyle subtitleStyle = OpTextStyle.labelMedium(context)
        .regular()
        .copyWith(color: OpDynamicColor.onSurfaceVariant(context));

    return PlatformListTile(
      onTap: onPressed,
      title: Skeleton.keep(
        child: Text(
          leadingText,
          style: titleStyle,
        ),
      ),
      subtitle:
          Skeleton.keep(child: Text(subtitleText, style: subtitleStyle)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            topTrailingText,
            style: titleStyle.spacedOut(),
          ),
          Text(
            bottomTrailingText,
            style: subtitleStyle.spacedOut(),
          ),
        ],
      ),
      cupertino: (_, __) =>
          CupertinoListTileData(padding: const EdgeInsets.all(OpSpacing.md)),
    );
  }
}
