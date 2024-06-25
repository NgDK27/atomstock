import 'package:flutter/material.dart';

import '../../../styles/opacities.dart';
import '../../../styles/radius.dart';

class MaterialPrimaryGlow extends BoxDecoration {
  MaterialPrimaryGlow(BuildContext context)
      : super(
    borderRadius: BorderRadius.circular(OpRadius.sm),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(OpOpacity.secondary),
        blurRadius: 2,
        spreadRadius: -5,
      ),
      BoxShadow(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(OpOpacity.secondary),
        blurRadius: 18,
        spreadRadius: -8,
      ),
    ],
  );
}