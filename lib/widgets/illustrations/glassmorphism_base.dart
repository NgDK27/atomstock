import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

abstract class GlassmorphismIllustration extends StatelessWidget {
  final Color overlayBeginColor;
  final Color overlayEndColor;
  final Color underlyingBeginColor;
  final Color underlyingEndColor;
  final Color overlayBorderColor;

  const GlassmorphismIllustration({
    super.key,
    this.overlayBeginColor = OpColor.aqua100,
    this.overlayEndColor = OpColor.grape60,
    this.underlyingBeginColor = OpColor.aqua100,
    this.underlyingEndColor = OpColor.grape60,
    this.overlayBorderColor = Colors.white,
  });

  // Underlying SVG
  String get underlyingSvg;

  double get underlyingTopPositionOffset => 0;
  double get underlyingLeftPositionOffset => 0;
  double get underlyingBottomPositionOffset => 0;
  double get underlyingRightPositionOffset => 0;
  Alignment get underlyingAlignment => Alignment.center;

  // Overlay SVG
  String get overlaySvgPath;

  double get overlayWidth;

  double get overlayHeight;

  double get overlayBorderWidth => 1.2;

  // Topmost SVG
  String get topmostSvgPath => "";
  double get topmostWidth => 0;
  double get topmostHeight => 0;
  double get topmostTopPositionOffset => 0;
  double get topmostLeftPositionOffset => 0;
  double get topmostBottomPositionOffset => 0;
  double get topmostRightPositionOffset => 0;
  Alignment get topmostAlignment => Alignment.center;

  GlassmorphismIllustration copyWith();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Underlying SVG
        Positioned(
            top: underlyingTopPositionOffset,
            left: underlyingLeftPositionOffset,
            bottom: underlyingBottomPositionOffset,
            right: underlyingRightPositionOffset,
            child: Align(
                alignment: underlyingAlignment,
                child: SvgPicture.string(underlyingSvg))),
        // Overlay SVG
        ClipPath(
          clipper: SVGPathClipper(overlaySvgPath),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: overlayWidth,
              height: overlayHeight,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      overlayBeginColor.withOpacity(0.1),
                      overlayEndColor.withOpacity(0.1)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.08),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0.0, 3.0),
                    )
                  ]),
            ),
          ),
        ),
        // Overlay SVG Outline
        CustomPaint(
          painter: SVGBorderPainter(overlaySvgPath,
              overlayBorderColor.withOpacity(0.3), overlayBorderWidth),
          size: Size(overlayWidth, overlayHeight),
        ),
        // Topmost SVG
        Positioned(
            bottom: topmostBottomPositionOffset,
            left: topmostLeftPositionOffset,
            right: topmostRightPositionOffset,
            top: topmostTopPositionOffset,
            child: Align(
              alignment: topmostAlignment,
              child: ClipPath(
                clipper: SVGPathClipper(topmostSvgPath),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: topmostWidth,
                    height: topmostHeight,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            overlayBeginColor.withOpacity(0.1),
                            overlayEndColor.withOpacity(0.1)
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 50,
                            spreadRadius: 5,
                            offset: const Offset(0.0, 3.0),
                          )
                        ]),
                  ),
                ),
              ),
            )),
        // Topmost SVG Outline
        Positioned(
            bottom: topmostBottomPositionOffset,
            left: topmostLeftPositionOffset,
            right: topmostRightPositionOffset,
            top: topmostTopPositionOffset,
            child: Align(
                alignment: topmostAlignment,
                child: CustomPaint(
                  painter: SVGBorderPainter(topmostSvgPath,
                      overlayBorderColor.withOpacity(0.3), overlayBorderWidth),
                  size: Size(overlayWidth, overlayHeight),
                  child: SizedBox(
                    width: topmostWidth,
                    height: topmostHeight,
                  ),
                ))),
      ],
    );
  }
}
