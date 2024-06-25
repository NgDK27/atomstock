import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';

class AlarmClockIllustration extends GlassmorphismIllustration {
  const AlarmClockIllustration({super.key});

  @override
  String get underlyingSvg =>
      '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 265 105">
  <rect width="85.532" height="55.007" x="204.508" y=".622" fill="url(#a)" rx="26.667" transform="rotate(45 204.508 .622)"/>
  <rect width="85.532" height="61.959" fill="url(#b)" rx="26.667" transform="scale(-1 1) rotate(45 -31.325 -73.502)"/>
  <defs>
    <linearGradient id="a" x1="208.072" x2="298.872" y1="11.623" y2="31.233" gradientUnits="userSpaceOnUse">
      <stop offset="-1" stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
    <linearGradient id="b" x1="3.564" x2="95.23" y1="12.392" y2="29.967" gradientUnits="userSpaceOnUse">
      <stop offset="-1" stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
  </defs>
</svg>''';

  @override
  double get underlyingTopPositionOffset => -15;

  @override
  Alignment get underlyingAlignment => Alignment.topCenter;

  @override
  String get overlaySvgPath =>
      "M0,120a120,120 0 1,0 240,0a120,120 0 1,0 -240,0";

  @override
  double get overlayWidth => 240;

  @override
  double get overlayHeight => 240;

  @override
  String get topmostSvgPath =>
      '''M13.333.667c7.364 0 13.334 5.97 13.334 13.333v72.45l60.193 36.117c6.314 3.788 8.362 11.979 4.573 18.293-3.788 6.314-11.979 8.362-18.293 4.573l-66.667-40A13.332 13.332 0 0 1 0 94V14C0 6.636 5.97.667 13.333.667Z''';

  @override
  double get topmostWidth => 94;

  @override
  double get topmostHeight => 148;

  @override
  double get topmostTopPositionOffset => -35;

  @override
  double get topmostLeftPositionOffset => 70;
}
