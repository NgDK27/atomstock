import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/fonts.dart';

final opCupertinoLightTheme = const CupertinoThemeData().copyWith(
  textTheme: opCupertinoTextTheme,
  primaryColor: OpDynamicColor.primary,
  primaryContrastingColor: OpDynamicColor.surface,
  barBackgroundColor: OpDynamicColor.surface.withAlpha(240),
  scaffoldBackgroundColor: OpDynamicColor.surface,
);

final opCupertinoDarkTheme = const CupertinoThemeData().copyWith(
  brightness: Brightness.dark,
  textTheme: opCupertinoTextTheme,
  primaryColor: OpDynamicColor.primary,
  primaryContrastingColor: OpDynamicColor.surface,
  barBackgroundColor: OpDynamicColor.surface.withAlpha(240),
  scaffoldBackgroundColor: OpDynamicColor.surface,
);
