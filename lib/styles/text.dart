import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class OpTextStyle {
  OpTextStyle._();

  static TextStyle? display(BuildContext context) => platformThemeData(context,
      material: (ThemeData data) => data.textTheme.displaySmall,
      cupertino: (CupertinoThemeData data) =>
          data.textTheme.navLargeTitleTextStyle);

  static TextStyle? headline(BuildContext context) => platformThemeData(context,
      material: (ThemeData data) => data.textTheme.headlineMedium,
      cupertino: (CupertinoThemeData data) => data.textTheme.navTitleTextStyle
          .copyWith(
              inherit: true,
              fontVariations: [FontVariation.weight(600)],
              fontSize:
                  (data.textTheme.navTitleTextStyle.fontSize ?? 16) * 1.2));
}
