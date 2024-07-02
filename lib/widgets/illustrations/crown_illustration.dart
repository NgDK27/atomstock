import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';
import 'glassmorphism_colors.dart';

class CrownIllustration extends GlassmorphismIllustration  with GlassmorphismColorMixin<CrownIllustration> {
  const CrownIllustration({super.key,
    super.overlayBeginColor,
    super.overlayEndColor,
    super.underlyingBeginColor,
    super.underlyingEndColor,
    super.overlayBorderColor,});

  @override
  String get underlyingSvg =>
      '''<svg fill="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 208 54"><path d="M8.142 10.766A13.333 13.333 0 0 1 21.077.666h165.846a13.333 13.333 0 0 1 12.935 10.1l7.495 29.98C209.036 47.478 203.944 54 197.005 54H10.995C4.055 54-1.036 47.478.647 40.746l7.495-29.98Z" fill="url(#a)"/><defs><linearGradient id="a" x1="6.222" y1="11.333" x2="187.354" y2="111.962" gradientUnits="userSpaceOnUse"><stop stop-color="${colorToHex(super.underlyingBeginColor)}" offset="-1"/><stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/></linearGradient></defs></svg>''';

  @override
  double get underlyingBottomPositionOffset => -20;

  @override
  Alignment get underlyingAlignment => Alignment.bottomCenter;

  @override
  String get overlaySvgPath =>
      "M10.133 117.327.89 24.913C-.243 13.567 12.463 6.124 21.805 12.663l34.3 24.01a13.333 13.333 0 0 0 16.426-.888L109.22 3.683a13.333 13.333 0 0 1 17.56 0l36.689 32.102a13.333 13.333 0 0 0 16.426.889l34.3-24.01c9.342-6.54 22.048.903 20.914 12.249l-9.242 92.414a13.332 13.332 0 0 1-13.267 12.006H23.4c-6.85 0-12.586-5.19-13.267-12.006Z";

  @override
  double get overlayWidth => 236;

  @override
  double get overlayHeight => 130;

  @override
  CrownIllustration copyWith({
    Color? overlayBeginColor,
    Color? overlayEndColor,
    Color? underlyingBeginColor,
    Color? underlyingEndColor,
    Color? overlayBorderColor,
  }) {
    return CrownIllustration(
      overlayBeginColor: overlayBeginColor ?? this.overlayBeginColor,
      overlayEndColor: overlayEndColor ?? this.overlayEndColor,
      underlyingBeginColor: underlyingBeginColor ?? this.underlyingBeginColor,
      underlyingEndColor: underlyingEndColor ?? this.underlyingEndColor,
      overlayBorderColor: overlayBorderColor ?? this.overlayBorderColor,
    );
  }
}
