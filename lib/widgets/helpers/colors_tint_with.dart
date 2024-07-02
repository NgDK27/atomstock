
import 'package:flutter/material.dart';

extension ColorTint on Color {
  Color tintWith(Color tintColor, double amount) {
    return Color.fromARGB(
      alpha,
      (red + (tintColor.red - red) * amount).round(),
      (green + (tintColor.green - green) * amount).round(),
      (blue + (tintColor.blue - blue) * amount).round(),
    );
  }

  Color tintWithPrimary(BuildContext context) {
    const double tintAmount = 0.2;
    return Color.fromARGB(
      alpha,
      (red + (Theme.of(context).colorScheme.primary.red - red) * tintAmount).round(),
      (green + (Theme.of(context).colorScheme.primary.green - green) * tintAmount).round(),
      (blue + (Theme.of(context).colorScheme.primary.blue - blue) * tintAmount).round(),
    );
  }
}

