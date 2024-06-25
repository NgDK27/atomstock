import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpTonalPrimaryButton.dart';
import 'package:oppenhomies/widgets/illustrations/glassmorphism_base.dart';
import 'package:prevent_orphan_text/prevent_orphan_text.dart';

class OnboardingLayout extends ConsumerWidget {
  final String title;
  final GlassmorphismIllustration illustration;
  final Alignment backgroundAlignment;
  final double backgroundScale;
  final VoidCallback onSignInPressed;
  final VoidCallback onGetStartedPressed;

  const OnboardingLayout({
    super.key,
    required this.title,
    required this.illustration,
    this.backgroundAlignment = Alignment.center,
    this.backgroundScale = 1.0,
    required this.onSignInPressed,
    required this.onGetStartedPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        ColorFiltered(
            colorFilter: ColorFilter.mode(
              platformThemeData(context,
                  material: (ThemeData data) => data.colorScheme.primary
                      .withOpacity(OpOpacity.quaternary),
                  cupertino: (_) =>
                      OpDynamicColor.primary.withOpacity(OpOpacity.quaternary)),
              BlendMode.srcOver,
            ),
            child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  platformThemeData(context,
                      material: (ThemeData data) => data.colorScheme.surface
                          .withOpacity(OpOpacity.quaternary),
                      cupertino: (_) => OpDynamicColor.surface
                          .withOpacity(OpOpacity.tertiary)),
                  BlendMode.srcOver,
                ),
                child: ClipRect(
                  child: Transform.scale(
                    scale: backgroundScale,
                    alignment: backgroundAlignment,
                    child: Image.asset(
                      'assets/images/onboarding_bg.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ))),
        SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: OpSpacing.xl),
              PreventOrphanText(
                title,
                style: platformThemeData(context,
                    material: (ThemeData data) => data.textTheme.displaySmall
                        ?.copyWith(color: data.colorScheme.onSurface),
                    cupertino: (CupertinoThemeData data) =>
                        data.textTheme.navLargeTitleTextStyle),
              ),
              Expanded(
                child: Center(
                  child: Transform.scale(
                    scale: 1.2,
                    child: illustration,
                  ),
                ),
              ),
              const SizedBox(height: OpSpacing.md),
              OpTonalPrimaryButton(
                text: "Sign in",
                onPressed: onSignInPressed,
              ),
              const SizedBox(height: OpSpacing.sm),
              OpFilledGlowPrimaryButton(
                text: "Get started",
                onPressed: onGetStartedPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
