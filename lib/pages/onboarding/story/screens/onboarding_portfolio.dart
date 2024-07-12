import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/widgets/illustrations/crown_illustration.dart';

import '../layouts/onboarding_content_layout.dart';

class OnboardingPortfolio extends ConsumerWidget {
  const OnboardingPortfolio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingContentLayout(
      title: "Command your portfolio, conquer the market",
      illustration: const CrownIllustration().withDynamicColors(context),
      backgroundScale: 4,
      backgroundAlignment: Alignment.centerRight,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
