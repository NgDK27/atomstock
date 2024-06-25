import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpTonalPrimaryButton.dart';
import 'package:oppenhomies/widgets/illustrations/alarm_clock_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/light_bulb_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/lightning_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/shield_check_illustration.dart';

import '../../../widgets/illustrations/crown_illustration.dart';
import '../../../widgets/illustrations/pie_chart_illustration.dart';


class OnboardingLayout extends StatelessWidget {
  final String title;

  const OnboardingLayout({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
            colorFilter: ColorFilter.mode(
              platformThemeData(context,
                  material: (ThemeData data) =>
                      data.colorScheme.surface.withAlpha(OpOpacity.secondary),
                  cupertino: (_) => OpDynamicColor.primary.withOpacity(0.1)),
              BlendMode.srcOver,
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                platformThemeData(context,
                    material: (ThemeData data) =>
                        data.colorScheme.surface.withAlpha(OpOpacity.secondary),
                    cupertino: (_) => OpDynamicColor.surface.withAlpha(OpOpacity.tertiary)),
                BlendMode.srcOver,
              ),
              child: SizedBox.expand(
                child: Image.asset(
                  'assets/images/onboarding_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            )),
        SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: OpSpacing.xl),
                Text(
                  title,
                  style: platformThemeData(context,
                      material: (ThemeData data) => data.textTheme.displayLarge,
                      cupertino: (CupertinoThemeData data) =>
                          data.textTheme.navLargeTitleTextStyle),
                ),
                Expanded(
                  child: Center(
                      child:
                    Transform.scale(
                      scale: 1.25,
                      child: AlarmClockIllustration(),
                    )
                  ),
                ),
                const SizedBox(height: OpSpacing.md),
                OpTonalPrimaryButton(
                    text: "Sign in", onPressed: () {} // TODO: sign in func
                    ),
                const SizedBox(height: OpSpacing.sm),
                OpFilledGlowPrimaryButton(
                    text: "Get started", onPressed: () {} // TODO: sign up func
                    )
              ],
            ))
      ],
    );
  }
}
