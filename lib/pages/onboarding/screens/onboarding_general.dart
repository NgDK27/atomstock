import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/widgets/illustrations/pie_chart_illustration.dart';

import '../layouts/onboarding_content_layout.dart';

class OnboardingGeneral extends ConsumerWidget {
  const OnboardingGeneral({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingContentLayout(
      title: "Invest like a genius, without the heavy lifting",
      illustration: const PieChartIllustration().withDynamicColors(context),
      backgroundScale: 2,
      backgroundAlignment: Alignment.topLeft,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
