import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';
import 'glassmorphism_colors.dart';

class RocketIllustration extends GlassmorphismIllustration  with GlassmorphismColorMixin<RocketIllustration> {
  const RocketIllustration({super.key,
    super.overlayBeginColor,
    super.overlayEndColor,
    super.underlyingBeginColor,
    super.underlyingEndColor,
    super.overlayBorderColor,});

  @override
  String get underlyingSvg =>
      '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 68 69">
  <path fill="url(#a)" d="M33.802 68.47C15.134 68.47 0 53.337 0 34.669 0 16 15.134.868 33.8.868c18.668 0 33.802 15.133 33.802 33.8 0 18.669-15.133 33.802-33.801 33.802Z"/>
  <defs>
    <linearGradient id="a" x1="26.233" x2="71.104" y1="-1.581" y2="57.764" gradientUnits="userSpaceOnUse">
      <stop offset='-1' stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
  </defs>
</svg>''';

  @override
  double get underlyingLeftPositionOffset => 60;

  @override
  double get underlyingTopPositionOffset => 50;

  @override
  Alignment get underlyingAlignment => Alignment.centerLeft;

  @override
  String get overlaySvgPath =>
      "M226.119 18.553C229.133 7.787 219.213-2.133 208.447.88L10.476 56.313C-1.465 59.657-3.817 75.557 6.644 82.214l81.732 52.012a14.333 14.333 0 0 1 4.398 4.398l52.012 81.732c6.657 10.462 22.557 8.11 25.901-3.832l55.432-197.971Z";

  @override
  double get overlayWidth => 227;

  @override
  double get overlayHeight => 227;

  @override
  String get topmostSvgPath =>
      '''M179.755 5.204a6.667 6.667 0 0 1-4.622 8.218L8.466 60.088a6.667 6.667 0 0 1-3.595-12.84L171.537.583a6.667 6.667 0 0 1 8.218 4.622Z''';

  @override
  double get topmostWidth => 180;

  @override
  double get topmostHeight => 61;

  @override
  double get topmostTopPositionOffset => 19;

  @override
  Alignment get topmostAlignment => Alignment.topCenter;

  @override
  RocketIllustration copyWith({
    Color? overlayBeginColor,
    Color? overlayEndColor,
    Color? underlyingBeginColor,
    Color? underlyingEndColor,
    Color? overlayBorderColor,
  }) {
    return RocketIllustration(
      overlayBeginColor: overlayBeginColor ?? this.overlayBeginColor,
      overlayEndColor: overlayEndColor ?? this.overlayEndColor,
      underlyingBeginColor: underlyingBeginColor ?? this.underlyingBeginColor,
      underlyingEndColor: underlyingEndColor ?? this.underlyingEndColor,
      overlayBorderColor: overlayBorderColor ?? this.overlayBorderColor,
    );
  }
}
