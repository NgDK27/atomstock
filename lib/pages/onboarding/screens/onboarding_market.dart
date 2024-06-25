import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/onboarding/widgets/onboarding_layout.dart';
import 'package:oppenhomies/widgets/illustrations/alarm_clock_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/light_bulb_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/lightning_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/pie_chart_illustration.dart';

class OnboardingMarket extends ConsumerWidget {
  const OnboardingMarket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingLayout(
      title: "Lightning fast access to real-time market data",
      illustration: const LightningIllustration(),
      backgroundScale: 4,
      backgroundAlignment: Alignment.bottomCenter,
      onSignInPressed: () {},
      onGetStartedPressed: () {},
    );
  }
}
