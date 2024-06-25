import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';

class PieChartIllustration extends GlassmorphismIllustration {
  const PieChartIllustration(
      {super.key, super.width = 214, super.height = 214});

  @override
  String getOverlaySvgPath() {
    return "M0,106.667a106.667,106.667 0 1,0 213.334,0a106.667,106.667 0 1,0 -213.334,0";
  }

  @override
  String getUnderlyingSvg() {
    return '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 133 133">
  <path fill="url(#a)" d="M132.728 12.728c0-7.364-5.984-13.402-13.311-12.667A133.337 133.337 0 0 0 9.544 81.703a133.337 133.337 0 0 0-9.483 37.714c-.735 7.327 5.303 13.311 12.667 13.311h106.667c7.363 0 13.333-5.97 13.333-13.333V12.728Z"/>
  <defs>
    <linearGradient id="a" x1="5.53" x2="150.215" y1="26.546" y2="46.641" gradientUnits="userSpaceOnUse">
      <stop offset="-1" stop-color="${colorToHex(super.underlyingBeginColor)}" />
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}" />
    </linearGradient>
  </defs>
</svg>''';
  }

  @override
  Widget getUnderlyingWidget() {
    return Positioned(
        bottom: 0,
        left: -25,
        right: 0,
        top: -25,
        child: Align(
            alignment: Alignment.topLeft,
            child: SvgPicture.string(getUnderlyingSvg())));
  }
}
