import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles/radius.dart';

abstract class OpButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? child;

  const OpButton({super.key, required this.text, this.onPressed, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformTextButton(

      onPressed: onPressed,
      cupertino: (_, __) => CupertinoTextButtonData(
        borderRadius: BorderRadius.circular(OpRadius.full),
        color: getCupertinoColor(context),
        alignment: alignment,
        padding: EdgeInsets.zero,
      ),
      material: (_, __) => MaterialTextButtonData(
          style: TextButton.styleFrom(
              alignment: alignment,
              padding: padding,
              disabledBackgroundColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              // From M3 doc
              backgroundColor: getMaterialBackgroundColor(context),
              overlayColor: getMaterialOverlayColor(context),),),
      child: child ?? Text(
        text,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: getTextColor(context),
            fontVariations: const [FontVariation.weight(600)],),
      ),
    );
  }

  Color getCupertinoColor(BuildContext context);

  Color getMaterialBackgroundColor(BuildContext context);

  Color getMaterialOverlayColor(BuildContext context);

  Color getTextColor(BuildContext context);

  AlignmentGeometry? get alignment => null;
  EdgeInsetsGeometry? get padding => null;
}
