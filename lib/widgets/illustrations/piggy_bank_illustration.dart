import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

import 'glassmorphism_base.dart';
import 'glassmorphism_colors.dart';

class PiggyBankIllustration extends GlassmorphismIllustration  with GlassmorphismColorMixin<PiggyBankIllustration> {
  const PiggyBankIllustration({super.key,
    super.overlayBeginColor,
    super.overlayEndColor,
    super.underlyingBeginColor,
    super.underlyingEndColor,
    super.overlayBorderColor,});

  @override
  String get underlyingSvg =>
      '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 94 94">
  <circle cx="46.997" cy="46.666" r="46.667" fill="url(#a)" transform="rotate(-45 46.997 46.666)"/>
  <defs>
    <linearGradient id="a" x1="4.219" x2="105.96" y1="18.666" y2="32.797" gradientUnits="userSpaceOnUse">
      <stop offset='-1' stop-color="${colorToHex(super.underlyingBeginColor)}"/>
      <stop offset="1" stop-color="${colorToHex(super.underlyingEndColor)}"/>
    </linearGradient>
  </defs>
</svg>''';

  @override
  double get underlyingBottomPositionOffset => -20;

  @override
  Alignment get underlyingAlignment => Alignment.topLeft;

  @override
  String get overlaySvgPath =>
      "M181.667 37.36c0 1.746.691 3.414 1.88 4.691a105.83 105.83 0 0 1 21.273 33.96c1.779 4.609 6.075 7.879 11.015 7.879 6.166 0 11.165 4.998 11.165 11.165V131c0 7.364-5.969 13.333-13.333 13.333h-1.187c-2.949 0-5.528 1.946-6.502 4.73a104.922 104.922 0 0 1-3.598 8.942c-1.406 3.078-1.797 6.547-.882 9.805l6.166 21.936a26.665 26.665 0 0 1-6.816 26.072l-.325.326c-10.414 10.414-27.298 10.414-37.712 0l-1.169-1.169c-4.11-4.11-10.378-5.003-15.762-2.817-12.277 4.985-25.702 7.731-39.769 7.731-14.066 0-27.491-2.746-39.768-7.731-5.385-2.186-11.653-1.293-15.762 2.816l-1.17 1.17c-10.413 10.414-27.298 10.414-37.712 0l-.325-.326a26.667 26.667 0 0 1-6.816-26.072l6.166-21.936c.916-3.258.524-6.726-.881-9.805-6.107-13.37-9.51-28.235-9.51-43.894 0-58.42 47.359-105.778 105.778-105.778 8.145 0 16.075.92 23.691 2.663a6.896 6.896 0 0 0 3.693-.154L164.168.755c8.624-2.836 17.499 3.588 17.499 12.666v23.94Z";

  @override
  double get overlayWidth => 227;

  @override
  double get overlayHeight => 224;

  @override
  String get topmostSvgPath =>
      '''M0,20a20,20 0 1,0 40,0a20,20 0 1,0 -40,0''';

  @override
  double get topmostWidth => 40;

  @override
  double get topmostHeight => 40;

  @override
  double get topmostTopPositionOffset => 65;

  @override
  double get topmostRightPositionOffset => 50;

  @override
  Alignment get topmostAlignment => Alignment.topRight;

  @override
  PiggyBankIllustration copyWith({
    Color? overlayBeginColor,
    Color? overlayEndColor,
    Color? underlyingBeginColor,
    Color? underlyingEndColor,
    Color? overlayBorderColor,
  }) {
    return PiggyBankIllustration(
      overlayBeginColor: overlayBeginColor ?? this.overlayBeginColor,
      overlayEndColor: overlayEndColor ?? this.overlayEndColor,
      underlyingBeginColor: underlyingBeginColor ?? this.underlyingBeginColor,
      underlyingEndColor: underlyingEndColor ?? this.underlyingEndColor,
      overlayBorderColor: overlayBorderColor ?? this.overlayBorderColor,
    );
  }
}
