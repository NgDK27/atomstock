import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/widgets/buttons/FilledButton.dart';
import 'package:oppenhomies/widgets/effects/shadows/CupertinoPrimaryGlow.dart';
import 'package:oppenhomies/widgets/effects/shadows/MaterialPrimaryGlow.dart';

import '../../styles/colors.dart';
import '../../styles/radius.dart';

class OpFilledGlowButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;

  const OpFilledGlowButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => DecoratedBox(
          decoration: CupertinoPrimaryGlow(),
          child: child),
      material: (_, child, __) => DecoratedBox(
          decoration: MaterialPrimaryGlow(context),
          child: child),
      child: OpFilledButton(
        text: text,
        onPressed: onPressed,
      ),
    );
  }
}
