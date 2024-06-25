import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/onboarding/widgets/onboarding_layout.dart';
import 'package:oppenhomies/widgets/illustrations/shield_check_illustration.dart';

class OnboardingSecurity extends ConsumerWidget {
  const OnboardingSecurity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingLayout(
      title: "Thieves lose, you win. Every time.",
      illustration: const ShieldCheckIllustration().withDynamicColors(context),
      backgroundScale: 2,
      backgroundAlignment: Alignment.topRight,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
