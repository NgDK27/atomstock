import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/onboarding/widgets/onboarding_layout.dart';
import 'package:oppenhomies/widgets/illustrations/light_bulb_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/pie_chart_illustration.dart';

class OnboardingAi extends ConsumerWidget {
  const OnboardingAi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingLayout(
      title: "Outsmart the market with your AI Advisor",
      illustration: const LightBulbIllustration(),
      backgroundScale: 2,
      backgroundAlignment: Alignment.bottomRight,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
