import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/effects/shadows/CupertinoPrimaryGlow.dart';
import 'package:oppenhomies/widgets/effects/shadows/MaterialPrimaryGlow.dart';

class OpFilledGlowPrimaryButton extends OpFilledPrimaryButton {
  const OpFilledGlowPrimaryButton({super.key, required super.text, super.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget button = super.build(context, ref);

    if (onPressed != null) {
      return PlatformWidgetBuilder(
        cupertino: (_, __, ___) =>
            DecoratedBox(decoration: CupertinoPrimaryGlow(), child: button),
        material: (_, __, ___) =>
            DecoratedBox(decoration: MaterialPrimaryGlow(context), child: button),
      );
    }

    return button;
  }
}