import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/fonts.dart';

final opCupertinoLightTheme = const CupertinoThemeData().copyWith(
  textTheme: opCupertinoTextTheme,
  primaryColor: OpLightDarkColor.primary,
  primaryContrastingColor: OpLightDarkColor.onSurface,
  barBackgroundColor: OpLightDarkColor.surface.withAlpha(240),
  scaffoldBackgroundColor: OpLightDarkColor.surface,
  applyThemeToAll: true,
);

final opCupertinoDarkTheme = const CupertinoThemeData().copyWith(
  brightness: Brightness.dark,
  textTheme: opCupertinoTextTheme,
  primaryColor: OpLightDarkColor.primary,
  primaryContrastingColor: OpLightDarkColor.surface,
  barBackgroundColor: OpLightDarkColor.surface.withAlpha(240),
  scaffoldBackgroundColor: OpLightDarkColor.surface,
  applyThemeToAll: true,
);
