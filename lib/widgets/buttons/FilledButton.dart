import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles/radius.dart';

class OpFilledButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;

  const OpFilledButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformElevatedButton(
      onPressed: onPressed,
      cupertino: (_, __) => CupertinoElevatedButtonData(
        borderRadius: BorderRadius.circular(OpRadius.full),
        color: CupertinoTheme.of(context).primaryColor,
      ),
      material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              overlayColor: Theme.of(context).colorScheme.onPrimary)),
      child: Text(
        text,
        style: TextStyle(
            color: platformThemeData(context,
                material: (ThemeData data) => data.colorScheme.onPrimary,
                cupertino: (CupertinoThemeData data) =>
                data.primaryContrastingColor),
            fontVariations: const [FontVariation.weight(600)]),
      ),
    );
  }
}
