import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';

class LightBulbIllustration extends GlassmorphismIllustration {
  const LightBulbIllustration({super.key});

  @override
  String get underlyingSvg =>
      '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 65 80">
  <path fill="url(#a)" d="M.203 14.44C-.444 6.668 5.69 0 13.491 0h37.685c7.8 0 13.935 6.667 13.287 14.44L60.02 67.775A13.333 13.333 0 0 1 46.732 80H17.935A13.333 13.333 0 0 1 4.648 67.774L.203 14.44Z"/>
  <defs>
    <linearGradient id="a" x1="1.778" x2="74.873" y1="16" y2="24.46" gradientUnits="userSpaceOnUse">
      <stop offset="-1" stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
  </defs>
</svg>''';

  @override
  double get underlyingBottomPositionOffset => -20;

  @override
  Alignment get underlyingAlignment => Alignment.bottomCenter;

  @override
  String get overlaySvgPath =>
      "M137.296 199.598c2.283-15.986 12.38-29.46 23.534-41.136 16.007-16.756 25.837-39.461 25.837-64.462 0-51.547-41.787-93.333-93.334-93.333C41.787.667 0 42.453 0 94c0 25.001 9.83 47.706 25.836 64.462 11.155 11.676 21.251 25.15 23.535 41.136l.692 4.84c1.876 13.137 13.127 22.895 26.398 22.895h33.744c13.271 0 24.522-9.758 26.399-22.895l.692-4.84Z";

  @override
  double get overlayWidth => 187;

  @override
  double get overlayHeight => 228;

  @override
  String get topmostSvgPath =>
      '''m13.896 14.83 10.387 41.552a6.667 6.667 0 0 1-12.935 3.234L.371 15.708C-1.925 6.52 6.825-1.582 15.808 1.413l18.134 6.045a33.333 33.333 0 0 0 21.081 0l18.134-6.045C82.141-1.58 90.89 6.521 88.594 15.708L77.617 59.616a6.667 6.667 0 1 1-12.935-3.234L75.069 14.83l-15.83 5.277a46.666 46.666 0 0 1-29.514 0l-15.83-5.277Z''';

  @override
  double get topmostWidth => 89;

  @override
  double get topmostHeight => 65;

  @override
  double get topmostBottomPositionOffset => -70;
}
