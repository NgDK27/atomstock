import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';

import '../OpButton.dart';


class OpTonalPrimaryButton extends OpButton {
  const OpTonalPrimaryButton({super.key, required super.text, super.onPressed});

  @override
  Color getCupertinoColor(BuildContext context) {
    return OpDynamicColor.secondaryContainer;
  }

  @override
  Color getMaterialBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondaryContainer;
  }

  @override
  Color getMaterialOverlayColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSecondaryContainer;
  }

  @override
  Color getTextColor(BuildContext context) {
    return platformThemeData(context,
        material: (ThemeData data) => data.colorScheme.onSecondaryContainer,
        cupertino: (CupertinoThemeData data) => data.primaryColor);
  }
}