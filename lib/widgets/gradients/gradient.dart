import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';

class OpGradient {
  static RadialGradient pageGradient(BuildContext context,
      {double radius = 1.5, required Color beginColor}) {
    return RadialGradient(
      center: Alignment.topRight,
      radius: radius,
      colors: [
        beginColor.withOpacity(OpOpacity.quaternary),
        beginColor.withOpacity(OpOpacity.quaternary * 2 / 3),
        beginColor.withOpacity(OpOpacity.quaternary * 1 / 3),
        beginColor.withOpacity(OpOpacity.quaternary * 1 / 6),
        beginColor.withOpacity(OpOpacity.quaternary * 1 / 15),
        OpDynamicColor.surface(context).withOpacity(OpOpacity.none),
      ],
      stops: const [0.0, 0.3, 0.5, 0.7, 0.9, 1.0],
    );
  }
}
