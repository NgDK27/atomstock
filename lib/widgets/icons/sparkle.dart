import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oppenhomies/styles/colors.dart';

class Sparkle extends StatelessWidget {
  const Sparkle({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" x="0px" y="0px"><path d="m21.5669,12.7007l-4.0422,2.0211c-1.213.6064-2.1965,1.59-2.8029,2.8029l-2.0211,4.0421c-.2887.5775-1.1127.5775-1.4015,0l-2.0211-4.0421c-.6064-1.213-1.59-2.1965-2.8029-2.8029l-4.0422-2.0211c-.5775-.2887-.5775-1.1127,0-1.4015l4.0422-2.0211c1.213-.6065,2.1965-1.5901,2.8029-2.803l2.0211-4.0421c.2887-.5775,1.1127-.5775,1.4015,0l2.0211,4.0421c.6064,1.213,1.59,2.1965,2.8029,2.803l4.0422,2.0211c.5775.2887.5775,1.1127,0,1.4015Z"/></svg>''',
      colorFilter:
          ColorFilter.mode(OpDynamicColor.onSurface(context), BlendMode.srcIn),
    );
  }
}
