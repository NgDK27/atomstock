import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/onboarding/widgets/onboarding_content_layout.dart';
import 'package:oppenhomies/widgets/illustrations/alarm_clock_illustration.dart';

class OnboardingTrading extends ConsumerWidget {
  const OnboardingTrading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingContentLayout(
      title: "Automated trading round the clock, never miss an opportunity",
      illustration: const AlarmClockIllustration().withDynamicColors(context),
      backgroundScale: 3,
      backgroundAlignment: Alignment.centerRight,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
