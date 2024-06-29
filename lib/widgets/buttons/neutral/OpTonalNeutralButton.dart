import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';

import '../OpButton.dart';


class OpTonalNeutralButton extends OpButton {
  const OpTonalNeutralButton({super.key, required super.text, super.onPressed});

  @override
  Color getCupertinoColor(BuildContext context) {
    return OpLightDarkColor.surfaceQuarternary;
  }

  @override
  Color getMaterialBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondaryContainer.withOpacity(OpOpacity.tertiary);
  }

  @override
  Color getMaterialOverlayColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSecondaryContainer;
  }

  @override
  Color getTextColor(BuildContext context) {
    return platformThemeData(context,
        material: (ThemeData data) => data.colorScheme.onSecondaryContainer,
        cupertino: (CupertinoThemeData data) => OpLightDarkColor.onSurface);
  }
}