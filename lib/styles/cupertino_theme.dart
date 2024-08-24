import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/fonts.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/opacities.dart';

final opCupertinoLightTheme = const CupertinoThemeData().copyWith(
  textTheme: opCupertinoTextTheme,
  primaryColor: OpLightDarkColor.primary,
  primaryContrastingColor: OpLightDarkColor.onSurface,
  barBackgroundColor: OpLightDarkColor.surface.withOpacity(0.8),
  scaffoldBackgroundColor: OpLightDarkColor.surface,
  applyThemeToAll: true,
);

final opCupertinoDarkTheme = const CupertinoThemeData().copyWith(
  brightness: Brightness.dark,
  textTheme: opCupertinoTextTheme,
  primaryColor: OpLightDarkColor.primary,
  primaryContrastingColor: OpLightDarkColor.surface,
  barBackgroundColor: OpLightDarkColor.surface.withOpacity(0.8),
  scaffoldBackgroundColor: OpLightDarkColor.surface,
  applyThemeToAll: true,
);
