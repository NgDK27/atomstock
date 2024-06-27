import 'package:oppenhomies/pages/onboarding/models/story_model.dart';

import '../screens/onboarding_ai.dart';
import '../screens/onboarding_general.dart';
import '../screens/onboarding_market.dart';
import '../screens/onboarding_portfolio.dart';
import '../screens/onboarding_security.dart';
import '../screens/onboarding_trading.dart';

final StoryModel onboardingStories = StoryModel([
  const OnboardingGeneral(),
  const OnboardingAi(),
  const OnboardingTrading(),
  const OnboardingMarket(),
  const OnboardingSecurity(),
  const OnboardingPortfolio()
]);
