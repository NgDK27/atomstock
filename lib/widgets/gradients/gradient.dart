import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';

class OpGradient {
  static RadialGradient pageGradient(BuildContext context,
      {double radius = 1.5, required Color beginColor}) {
    return RadialGradient(center: Alignment.topRight, radius: radius, colors: [
      platformThemeData(context,
          material: (ThemeData data) =>
              beginColor.harmonized(context).withOpacity(OpOpacity.quaternary),
          cupertino: (CupertinoThemeData data) =>
              beginColor.withOpacity(OpOpacity.quaternary)),
      OpDynamicColor.surface(context)
    ]);
  }
}
