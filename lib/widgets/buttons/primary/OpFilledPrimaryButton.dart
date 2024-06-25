import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../OpButton.dart';

class OpFilledPrimaryButton extends OpButton {
  const OpFilledPrimaryButton({super.key, required super.text, super.onPressed});

  @override
  Color getCupertinoColor(BuildContext context) {
    return CupertinoTheme.of(context).primaryColor;
  }

  @override
  Color getMaterialBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Color getMaterialOverlayColor(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimary;
  }

  @override
  Color getTextColor(BuildContext context) {
    return platformThemeData(context,
        material: (ThemeData data) => data.colorScheme.onPrimary,
        cupertino: (CupertinoThemeData data) => data.primaryContrastingColor);
  }
}

