import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';

class OpGradient {
  static RadialGradient pageGradient(
    BuildContext context, {
    double radius = 1.5,
    required Color beginColor,
    Alignment center = Alignment.topRight,
  }) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: OpGradient.fadeOutGradient(context, beginColor: beginColor),
      stops: OpGradient.fadeOutStops(),
    );
  }

  static List<Color> fadeOutGradient(
    BuildContext context, {
    required Color beginColor,
  }) =>
      [
        beginColor.withOpacity(OpOpacity.quaternary),
        beginColor.withOpacity(OpOpacity.quaternary * 2 / 3),
        beginColor.withOpacity(OpOpacity.quaternary * 1 / 3),
        beginColor.withOpacity(OpOpacity.quaternary * 1 / 6),
        beginColor.withOpacity(OpOpacity.quaternary * 1 / 15),
        OpDynamicColor.surface(context).withOpacity(OpOpacity.none),
      ];

  static List<Color> fadeOutGradientStrong(
      BuildContext context, {
        required Color beginColor,
      }) =>
      [
        beginColor.withOpacity(OpOpacity.tertiary),
        beginColor.withOpacity(OpOpacity.tertiary * 0.4),
        beginColor.withOpacity(OpOpacity.tertiary * 0.3),
        beginColor.withOpacity(OpOpacity.tertiary * 0.2),
        beginColor.withOpacity(OpOpacity.tertiary * 0.1),
        beginColor.withOpacity(OpOpacity.tertiary * 0),

      ];



  static List<double> fadeOutStops() =>
      [
        0.0,
        0.3,
        0.5,
        0.7,
        0.9,
        1.0,
      ];
}
