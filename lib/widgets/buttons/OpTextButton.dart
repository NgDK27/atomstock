import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/widgets/buttons/OpButton.dart';

class OpTextButton extends OpButton {
  const OpTextButton({super.key, required super.text, super.onPressed});

  @override
  Color getCupertinoColor(BuildContext context) {
    return Colors.transparent;
  }

  @override
  Color getMaterialBackgroundColor (BuildContext context) {
    return Colors.transparent;
  }

  @override
  Color getMaterialOverlayColor(BuildContext context ) {
    return Theme.of(context).colorScheme.primary;
  }

  @override getTextColor(BuildContext context) {
    return platformThemeData(context, material: (ThemeData data) => data.colorScheme.onSurface, cupertino: (CupertinoThemeData data) => OpDynamicColor.onSurface);
  }
}