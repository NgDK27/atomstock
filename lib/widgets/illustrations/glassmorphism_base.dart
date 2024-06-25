import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/widgets/illustrations/svg_helpers.dart';

abstract class GlassmorphismIllustration extends StatelessWidget {
  final double width;
  final double height;
  final Color overlayBeginColor;
  final Color overlayEndColor;
  final Color underlyingBeginColor;
  final Color underlyingEndColor;
  final Color overlayBorderColor;
  final double overlayBorderWidth;

  const GlassmorphismIllustration(
      {super.key,
      required this.width,
      required this.height,
      this.overlayBorderColor = Colors.white,
      this.overlayBorderWidth = 1.2,
      this.overlayBeginColor = OpColor.aqua100,
      this.overlayEndColor = OpColor.grape60,
      this.underlyingBeginColor = OpColor.aqua100,
      this.underlyingEndColor = OpColor.grape60});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        getUnderlyingWidget(),
        ClipPath(
          clipper: SVGPathClipper(getOverlaySvgPath()),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: width,
              height: height,
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
                      blurRadius: 20,
                      spreadRadius: -5,
                    )
                  ]),
            ),
          ),
        ),
        CustomPaint(
          painter: SVGBorderPainter(getOverlaySvgPath(),
              overlayBorderColor.withOpacity(0.3), overlayBorderWidth),
          size: Size(width, height),
        ),
      ],
    );
  }

  String getOverlaySvgPath();

  String getUnderlyingSvg();

  Widget getUnderlyingWidget() {
    return const SizedBox.shrink();
  }
}


// class LightningIllustration extends GlassmorphismIllustration {
//   const LightningIllustration(
//       {super.key, super.width = 202, super.height = 265});
//
//   @override
//   String getOverlaySvgPath() {
//     return "M1.29 154.252 127.78 2.463c3.503-4.204 10.309-1.035 9.347 4.352l-17.414 97.518h76.232c4.522 0 6.992 5.274 4.098 8.748L75.558 262.464c-3.627 4.352-10.641.795-9.273-4.703L89.873 163H5.387c-4.522 0-6.992-5.274-4.097-8.748Z";
//   }
//
//   @override
//   String getUnderlyingSvg() {
//     return '''<svg fill="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 208 54"><path d="M8.142 10.766A13.333 13.333 0 0 1 21.077.666h165.846a13.333 13.333 0 0 1 12.935 10.1l7.495 29.98C209.036 47.478 203.944 54 197.005 54H10.995C4.055 54-1.036 47.478.647 40.746l7.495-29.98Z" fill="url(#a)"/><defs><linearGradient id="a" x1="6.222" y1="11.333" x2="187.354" y2="111.962" gradientUnits="userSpaceOnUse"><stop stop-color="#00F5FA"/><stop offset="1" stop-color="#A586F4"/></linearGradient></defs></svg>''';
//   }
// }
