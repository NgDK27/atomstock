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
      material: (ThemeData data) => data.textTheme.headlineSmall,
      cupertino: (CupertinoThemeData data) => data.textTheme.navTitleTextStyle
          .copyWith(
              inherit: true,
              fontVariations: [FontVariation.weight(600)],
              fontSize:
                  (data.textTheme.navTitleTextStyle.fontSize ?? 16) * 1.2));

  static TextStyle? body(BuildContext context) => platformThemeData(context,
      material: (ThemeData data) => data.textTheme.bodyMedium,
      cupertino: (CupertinoThemeData data) => data.textTheme.textStyle);

  static TextStyle? labelLarge(BuildContext context) => platformThemeData(context,
      material: (ThemeData data) => data.textTheme.labelLarge,
      cupertino: (CupertinoThemeData data) => data.textTheme.textStyle
          .copyWith(
          inherit: true,
          letterSpacing: 0.1,
          fontSize:
          (data.textTheme.textStyle.fontSize ?? 17) * 0.88));


  static TextStyle? labelMedium(BuildContext context) => platformThemeData(
      context,
      material: (ThemeData data) => data.textTheme.labelMedium,
      cupertino: (CupertinoThemeData data) => data.textTheme.tabLabelTextStyle
          .copyWith(
              inherit: true,
              fontSize:
                  (data.textTheme.tabLabelTextStyle.fontSize ?? 10) * 1.3));

  static TextStyle? labelMediumProminent(BuildContext context) =>
      platformThemeData(context,
          material: (ThemeData data) => data.textTheme.labelMedium,
          cupertino: (CupertinoThemeData data) =>
              data.textTheme.tabLabelTextStyle.copyWith(
                  fontVariations: [FontVariation.weight(600)],
                  fontSize:
                      (data.textTheme.tabLabelTextStyle.fontSize ?? 10) * 1.3));
}
