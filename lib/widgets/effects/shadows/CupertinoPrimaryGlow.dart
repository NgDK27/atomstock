import 'package:flutter/cupertino.dart';

import '../../../styles/colors.dart';
import '../../../styles/radius.dart';

class CupertinoPrimaryGlow extends BoxDecoration {
  CupertinoPrimaryGlow()
      : super(
    borderRadius: BorderRadius.circular(OpRadius.full),
    boxShadow: [
      BoxShadow(
        color: OpDynamicColor.primarySecondary,
        blurRadius: 4,
      ),
      BoxShadow(
        color: OpDynamicColor.primarySecondary,
        blurRadius: 12,
        spreadRadius: 2,
      ),
    ],
  );
}
