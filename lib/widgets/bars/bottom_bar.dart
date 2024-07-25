import 'package:flutter/cupertino.dart';

import '../../styles/colors.dart';
import '../../styles/spacings.dart';

class BottomBar extends StatelessWidget {
  final Widget child;

  const BottomBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                top:
                    BorderSide(color: OpDynamicColor.outlineVariant(context)),),
        color: OpDynamicColor.surface(context),),
        child: SafeArea(
            top: false,
            minimum: const EdgeInsets.symmetric(
                horizontal: OpSpacing.md, vertical: OpSpacing.sm,),
            child: child,),);
  }
}
