import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';

import '../OpButton.dart';

class OpFilledNeutralButton extends OpButton {
  const OpFilledNeutralButton({super.key, required super.text, super.onPressed});

  @override
  Color getCupertinoColor(BuildContext context) {
    return OpLightDarkColor.surfaceInverse;
  }

  @override
  Color getMaterialBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  @override
  Color getMaterialOverlayColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  @override
  Color getTextColor(BuildContext context) {
    return platformThemeData(context,
        material: (ThemeData data) => data.colorScheme.surface,
        cupertino: (CupertinoThemeData data) => OpLightDarkColor.onSurfaceInverse,);
  }
}

