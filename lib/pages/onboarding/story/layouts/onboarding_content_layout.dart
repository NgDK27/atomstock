import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/cupertino_theme.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/colors_tint_with.dart';
import 'package:oppenhomies/widgets/illustrations/glassmorphism_base.dart';
import 'package:oppenhomies/widgets/story/story_header.dart';
import 'package:prevent_orphan_text/prevent_orphan_text.dart';



class OnboardingContentLayout extends ConsumerWidget {
  final String title;
  final GlassmorphismIllustration illustration;
  final Alignment backgroundAlignment;
  final double backgroundScale;
  final VoidCallback onSignInPressed;
  final VoidCallback onGetStartedPressed;

  const OnboardingContentLayout({
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
    final PlatformTarget currentPlatform = platform(context);

    switch (currentPlatform) {
      case PlatformTarget.iOS:
        {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        }
      case PlatformTarget.android:
        {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),);
        }
      default:
        {}
    }

    return PlatformWidgetBuilder(
        material: (_, child, __) => Theme(
            data: Theme.of(context).copyWith(brightness: Brightness.dark),
            child: child!,),
        cupertino: (_, child, __) =>
            CupertinoTheme(data: opCupertinoDarkTheme, child: child!),
        child: Stack(
          children: [
            ColorFiltered(
                colorFilter: ColorFilter.mode(
                  platformThemeData(context,
                      material: (ThemeData data) => data.colorScheme.primary
                          .withOpacity(OpOpacity.quaternary),
                      cupertino: (CupertinoThemeData data) =>
                          data.primaryColor.withOpacity(OpOpacity.quaternary),),
                  BlendMode.srcOver,
                ),
                child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      platformThemeData(context,
                          material: (ThemeData data) => data.colorScheme.surface
                              .withOpacity(OpOpacity.quaternary),
                          cupertino: (_) => OpColor.charcoal120
                              .withOpacity(OpOpacity.tertiary),),
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
                    ),),),
            SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: OpSpacing.sm),
                  const StoryHeader(),
                  const SizedBox(height: OpSpacing.xl),
                  PreventOrphanText(title,
                      style: OpTextStyle.display(context)?.copyWith(
                          inherit: true,
                          color: switch (currentPlatform) {
                            PlatformTarget.android =>
                              OpColor.mono100.tintWithPrimary(context),
                            PlatformTarget.iOS => OpColor.mono100,
                            _ => OpTextStyle.display(context)?.color,
                          },),),
                  Expanded(
                    child: Center(
                      child: Transform.scale(
                        scale: 1.2,
                        child: illustration,
                      ),
                    ),
                  ),
                  const SizedBox(height: OpSpacing.md),
                  SizedBox.fromSize(
                    child: PlatformTextButton(
                      color: Colors.transparent,
                      onPressed: () {},
                      child: const Text(""),
                    ),
                  ),
                  const SizedBox(height: OpSpacing.md),
                  SizedBox.fromSize(
                    child: PlatformTextButton(
                      color: Colors.transparent,
                      onPressed: () {},
                      child: const Text(""),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),);
  }
}
