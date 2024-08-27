import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class OpTitleLarge extends StatelessWidget {
  final Widget? leading;
  final String title;
  final VoidCallback? onPressed;

  const OpTitleLarge(
    this.title, {
    super.key,
    this.leading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidgetBuilder(
      material: (_, child, __) => InkWell(
        onTap: onPressed,
        child: child,
      ),
      cupertino: (_, child, __) => GestureDetector(
        onTap: onPressed,
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: OpSpacing.md,
          vertical: OpSpacing.md,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: platformThemeData(
                context,
                material: (_) => MainAxisAlignment.spaceBetween,
                cupertino: (_) => MainAxisAlignment.start,
              ),
              children: [
                Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: OpSpacing.xs),
                    ],
                    Text(
                      title,
                      style: OpTextStyle.titleMedium(context)?.copyWith(
                        fontVariations: [const FontVariation.weight(600)],
                      ),
                    ),
                  ],
                ),
                if (onPressed != null)
                  Row(
                    children: [
                      const SizedBox(
                        width: OpSpacing.xs3,
                      ),
                      Icon(
                        platformThemeData(
                          context,
                          material: (_) => Symbols.arrow_forward_rounded,
                          cupertino: (_) => Symbols.chevron_forward_rounded,
                        ),
                        weight: 800,
                        size: platformThemeData(
                          context,
                          material: (_) => 24,
                          cupertino: (_) => 32,
                        ),
                        color: platformThemeData(context,
                            material: (_) => OpDynamicColor.onSurface(context),
                            cupertino: (_) =>
                                OpDynamicColor.onSurfaceVariant(context),),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
