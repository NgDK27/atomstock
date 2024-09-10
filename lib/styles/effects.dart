import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:skeletonizer/skeletonizer.dart';

ShimmerEffect opShimmerEffect(BuildContext context) {
  return ShimmerEffect(
    baseColor: OpDynamicColor.primaryVariant(context).withOpacity(OpOpacity.tertiary),
    highlightColor: OpDynamicColor.surface(context),
  );
}
