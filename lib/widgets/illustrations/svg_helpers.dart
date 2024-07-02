import 'package:flutter/cupertino.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class SVGPathClipper extends CustomClipper<Path> {
  final String svgPath;

  SVGPathClipper(this.svgPath);

  @override
  Path getClip(Size size) {
    return parseSvgPath(svgPath);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SVGBorderPainter extends CustomPainter {
  final String svgPath;
  final Color borderColor;
  final double borderWidth;

  SVGBorderPainter(this.svgPath, this.borderColor, this.borderWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final path = parseSvgPath(svgPath);
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2)}';
}