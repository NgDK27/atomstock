import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/widgets/buttons/OpButton.dart';

class OpNeutralTextButton extends OpButton {
  final bool leftAligned;

  const OpNeutralTextButton(
      {super.key,
      required super.text,
      super.onPressed,
      this.leftAligned = false});

  @override
  Color getCupertinoColor(BuildContext context) {
    return Colors.transparent;
  }

  @override
  Color getMaterialBackgroundColor(BuildContext context) {
    return Colors.transparent;
  }

  @override
  Color getMaterialOverlayColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  @override
  getTextColor(BuildContext context) {
    return platformThemeData(context,
        material: (ThemeData data) => data.colorScheme.onSurface,
        cupertino: (CupertinoThemeData data) => OpLightDarkColor.onSurface);
  }

  @override
  AlignmentGeometry? get alignment => leftAligned ? Alignment.centerLeft : super.alignment;

  @override
  EdgeInsetsGeometry? get padding => leftAligned ? EdgeInsets.zero : super.padding;
}
