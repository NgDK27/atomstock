import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledPrimaryButton.dart';
import 'package:oppenhomies/widgets/effects/shadows/CupertinoPrimaryGlow.dart';
import 'package:oppenhomies/widgets/effects/shadows/MaterialPrimaryGlow.dart';

class OpFilledGlowPrimaryButton extends OpFilledPrimaryButton {
  const OpFilledGlowPrimaryButton({super.key, required super.text, super.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) =>
          DecoratedBox(decoration: CupertinoPrimaryGlow(), child: child),
      material: (_, child, __) =>
          DecoratedBox(decoration: MaterialPrimaryGlow(context), child: child),
      child: super.build(context, ref),
    );
  }
}
