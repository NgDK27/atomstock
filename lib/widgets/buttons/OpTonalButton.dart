import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/colors.dart';

import '../../styles/radius.dart';

class OpTonalButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;

  const OpTonalButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformTextButton(
      onPressed: onPressed,
      cupertino: (_, __) => CupertinoTextButtonData(
        borderRadius: BorderRadius.circular(OpRadius.full),
        color: OpDynamicColor.secondaryContainer,
      ),
      material: (_, __) => MaterialTextButtonData(
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              overlayColor: Theme.of(context).colorScheme.onSecondaryContainer)),
      child: Text(
        text,
        style: TextStyle(
            color: platformThemeData(context,
                material: (ThemeData data) => data.colorScheme.onSecondaryContainer,
                cupertino: (CupertinoThemeData data) =>
                data.primaryColor),
            fontVariations: const [FontVariation.weight(600)]),
      ),
    );
  }
}
