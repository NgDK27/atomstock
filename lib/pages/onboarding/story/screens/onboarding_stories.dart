
import 'package:oppenhomies/pages/onboarding/story/models/story_model.dart';

import 'onboarding_ai.dart';
import 'onboarding_general.dart';
import 'onboarding_market.dart';
import 'onboarding_portfolio.dart';
import 'onboarding_security.dart';
import 'onboarding_trading.dart';

final StoryModel onboardingStories = StoryModel([
  const OnboardingGeneral(),
  const OnboardingAi(),
  const OnboardingTrading(),
  const OnboardingMarket(),
  const OnboardingSecurity(),
  const OnboardingPortfolio(),
]);
