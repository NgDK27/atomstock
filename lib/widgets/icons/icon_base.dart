import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oppenhomies/styles/colors.dart';


abstract class IconBase extends StatelessWidget {
  final Color? color;

  const IconBase({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      iconString,
      colorFilter: ColorFilter.mode(
        color ?? OpDynamicColor.onSurface(context),
        BlendMode.srcIn,
      ),
    );
  }

  String get iconString;

  IconBase copyWith({Color? color});
}