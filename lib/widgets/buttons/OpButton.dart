import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles/radius.dart';

abstract class OpButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;

  const OpButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformElevatedButton(
      onPressed: onPressed,
      cupertino: (_, __) => CupertinoElevatedButtonData(
        borderRadius: BorderRadius.circular(OpRadius.full),
        color: getCupertinoColor(context),
      ),
      material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
              backgroundColor: getMaterialBackgroundColor(context),
              overlayColor: getMaterialOverlayColor(context))),
      child: Text(
        text,
        style: TextStyle(
            color: getTextColor(context),
            fontVariations: const [FontVariation.weight(600)]),
      ),
    );
  }

  Color getCupertinoColor(BuildContext context);
  Color getMaterialBackgroundColor(BuildContext context);
  Color getMaterialOverlayColor(BuildContext context);
  Color getTextColor(BuildContext context);
}