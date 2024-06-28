import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/widgets/illustrations/shield_check_illustration.dart';

import '../layouts/onboarding_content_layout.dart';

class OnboardingSecurity extends ConsumerWidget {
  const OnboardingSecurity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingContentLayout(
      title: "Thieves lose, you win. Every time.",
      illustration: const ShieldCheckIllustration().withDynamicColors(context),
      backgroundScale: 2,
      backgroundAlignment: Alignment.topRight,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
