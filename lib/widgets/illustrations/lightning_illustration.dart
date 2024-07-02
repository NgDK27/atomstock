import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';
import 'glassmorphism_colors.dart';

class LightningIllustration extends GlassmorphismIllustration
    with GlassmorphismColorMixin<LightningIllustration> {
  const LightningIllustration({
    super.key,
    super.overlayBeginColor,
    super.overlayEndColor,
    super.underlyingBeginColor,
    super.underlyingEndColor,
    super.overlayBorderColor,
  });

  @override
  String get underlyingSvg =>
      '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 187 210">
  <rect width="137.052" height="37.273" x="70" y="185.65" fill="url(#a)" rx="18.637" transform="rotate(-49.78 70 185.65)"/>
  <rect width="137.052" height="37.273" y="104.65" fill="url(#b)" rx="18.637" transform="rotate(-49.78 0 104.65)"/>
  <defs>
    <linearGradient id="a" x1="75.71" x2="196.491" y1="193.105" y2="254.785" gradientUnits="userSpaceOnUse">
      <stop offset="-1" stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
    <linearGradient id="b" x1="5.71" x2="126.491" y1="112.105" y2="173.785" gradientUnits="userSpaceOnUse">
      <stop offset="-1" stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
  </defs>
</svg>''';

  @override
  Alignment get underlyingAlignment => Alignment.center;

  @override
  String get overlaySvgPath =>
      "M1.29 154.586 127.78 2.796c3.503-4.203 10.309-1.035 9.347 4.352l-17.414 97.519h76.232c4.522 0 6.992 5.274 4.098 8.747L75.558 262.797c-3.627 4.353-10.641.795-9.273-4.702l23.588-94.762H5.387c-4.522 0-6.992-5.273-4.097-8.747Z";

  @override
  double get overlayWidth => 202;

  @override
  double get overlayHeight => 265;

  @override
  LightningIllustration copyWith({
    Color? overlayBeginColor,
    Color? overlayEndColor,
    Color? underlyingBeginColor,
    Color? underlyingEndColor,
    Color? overlayBorderColor,
  }) {
    return LightningIllustration(
      overlayBeginColor: overlayBeginColor ?? this.overlayBeginColor,
      overlayEndColor: overlayEndColor ?? this.overlayEndColor,
      underlyingBeginColor: underlyingBeginColor ?? this.underlyingBeginColor,
      underlyingEndColor: underlyingEndColor ?? this.underlyingEndColor,
      overlayBorderColor: overlayBorderColor ?? this.overlayBorderColor,
    );
  }
}
