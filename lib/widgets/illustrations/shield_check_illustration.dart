import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';

class ShieldCheckIllustration extends GlassmorphismIllustration {
  const ShieldCheckIllustration({super.key});

  @override
  String get underlyingSvg =>
      '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 121 121">
  <circle cx="60.853" cy="60.853" r="60" fill="url(#a)" transform="rotate(45 60.853 60.853)"/>
  <defs>
    <linearGradient id="a" x1="5.853" x2="136.663" y1="24.853" y2="43.021" gradientUnits="userSpaceOnUse">
      <stop offset="-1" stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
  </defs>
</svg>''';

  @override
  double get underlyingBottomPositionOffset => -15;

  @override
  double get underlyingRightPositionOffset => -15;

  @override
  Alignment get underlyingAlignment => Alignment.bottomRight;

  @override
  String get overlaySvgPath =>
      "m172.315 7.616-22.413-3.202a400.001 400.001 0 0 0-113.137 0L14.35 7.616A16.715 16.715 0 0 0 0 24.164v44.628c0 62.378 33.424 119.974 87.584 150.923a11.592 11.592 0 0 0 11.499 0c54.159-30.949 87.584-88.545 87.584-150.923V24.164c0-8.319-6.117-15.371-14.352-16.548Z";

  @override
  double get overlayWidth => 187;

  @override
  double get overlayHeight => 222;

  @override
  String get topmostSvgPath =>
      '''M103.32 21.321a12.437 12.437 0 0 0 0-17.663c-4.906-4.877-12.861-4.877-17.767 0l-46.46 46.185-17.312-17.211c-4.906-4.878-12.861-4.878-17.768 0a12.438 12.438 0 0 0 0 17.663l25.942 25.789a12.546 12.546 0 0 0 8.374 3.893 12.575 12.575 0 0 0 9.924-3.913l55.067-54.743Z''';

  @override
  double get topmostWidth => 107;

  @override
  double get topmostHeight => 80;
}
