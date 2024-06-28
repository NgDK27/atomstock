import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/widgets/illustrations/lightning_illustration.dart';

import '../layouts/onboarding_content_layout.dart';

class OnboardingMarket extends ConsumerWidget {
  const OnboardingMarket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingContentLayout(
      title: "Lightning fast access to real-time market data",
      illustration: const LightningIllustration().withDynamicColors(context),
      backgroundScale: 4,
      backgroundAlignment: Alignment.bottomCenter,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
