import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const interFontFeatures = <FontFeature>[
  FontFeature.enable('tnum'),
  FontFeature.enable('pnum'),
  FontFeature.enable('opsz'),
  FontFeature.enable('cv01'),
  FontFeature.enable('cv02'),
  FontFeature.enable('cv03'),
  FontFeature.enable('cv04'),
  FontFeature.enable('cv06'),
  FontFeature.enable('cv09'),
  FontFeature.enable('cv10'),
  FontFeature.enable('cv11'),
];

final opMaterialTextTheme = const TextTheme().copyWith(
  displayLarge: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  displayMedium: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  displaySmall: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  headlineLarge: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  headlineMedium: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  headlineSmall: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  titleLarge: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  titleMedium: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  titleSmall: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  bodyLarge: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  bodyMedium: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  bodySmall: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  labelLarge: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
  labelMedium: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
    fontVariations: [
      FontVariation.weight(550),
    ],
  ),
  labelSmall: const TextStyle(
    fontFamily: "Inter",
    fontFeatures: interFontFeatures,
  ),
);

final opCupertinoTextTheme = const CupertinoTextThemeData().copyWith(
    textStyle: const CupertinoTextThemeData().textStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,
      letterSpacing: 0,
    ),
    actionTextStyle: const CupertinoTextThemeData().actionTextStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,

    ),
    tabLabelTextStyle: const CupertinoTextThemeData().tabLabelTextStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,
    ),
    navTitleTextStyle: const CupertinoTextThemeData().navTitleTextStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,
      fontVariations: [
        const FontVariation.weight(500),
      ],
    ),
    navLargeTitleTextStyle: const CupertinoTextThemeData().navLargeTitleTextStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,
    ),
    navActionTextStyle: const CupertinoTextThemeData().navActionTextStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,
    ),
    pickerTextStyle: const CupertinoTextThemeData().pickerTextStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,
    ),
    dateTimePickerTextStyle: const CupertinoTextThemeData().dateTimePickerTextStyle.copyWith(
      fontFamily: "Inter",
      fontFeatures: interFontFeatures,
    ),);
