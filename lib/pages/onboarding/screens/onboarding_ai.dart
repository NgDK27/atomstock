import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/onboarding/widgets/onboarding_content_layout.dart';
import 'package:oppenhomies/widgets/illustrations/light_bulb_illustration.dart';

class OnboardingAi extends ConsumerWidget {
  const OnboardingAi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingContentLayout(
      title: "Outsmart the market with your AI Advisor",
      illustration: const LightBulbIllustration().withDynamicColors(context),
      backgroundScale: 2,
      backgroundAlignment: Alignment.bottomRight,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
