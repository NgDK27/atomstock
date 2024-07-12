import 'package:flutter/widgets.dart';
import 'package:oppenhomies/navigation/extensions/fade_transition.dart';
import 'package:oppenhomies/pages/ai/screens/ai.dart';
import 'package:oppenhomies/pages/authentication/landing/screens/sign_in_landing.dart';
import 'package:oppenhomies/pages/authentication/landing/screens/sign_up_landing.dart';
import 'package:oppenhomies/pages/authentication/reset_password/screens/reset_password.dart';
import 'package:oppenhomies/pages/authentication/sign_in/screens/sign_in.dart';
import 'package:oppenhomies/pages/authentication/sign_up/screens/sign_up.dart';
import 'package:oppenhomies/pages/authentication/sign_up/screens/sign_up_verify.dart';
import 'package:oppenhomies/pages/automations/screens/automations.dart';
import 'package:oppenhomies/pages/home/screens/home.dart';
import 'package:oppenhomies/pages/market/screens/market.dart';
import 'package:oppenhomies/pages/notifications/screens/notifications.dart';
import 'package:oppenhomies/pages/onboarding/ai_select/screens/ai_select.dart';
import 'package:oppenhomies/pages/onboarding/story/screens/onboarding_story.dart';
import 'package:oppenhomies/pages/portfolio/screens/portfolio.dart';
import 'package:oppenhomies/pages/settings/screens/settings.dart';

import 'models/route_model.dart';

class OpRoutes {
  OpRoutes._();

  // For development
  static final developing = RouteModel(
    path: '/developing',
    name: 'developing',
    builder: (context, state) => const SignUp(),
  );

  // Main app routes
  static final home = RouteModel(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) => buildPageWithFadeTransition(context:context, state: state, child: const Home()));

  static final ai = RouteModel(
    path: '/ai',
    name: 'ai',
    pageBuilder: (context, state) => buildPageWithFadeTransition(context:context, state: state, child: const Ai()),
  );

  static final automations = RouteModel(
    path: '/automations',
    name: 'automations',
    pageBuilder: (context, state) =>
        buildPageWithFadeTransition(context:context, state: state, child: const Automations()),
  );

  static final market = RouteModel(
    path: '/market',
    name: 'market',
    pageBuilder: (context, state) => buildPageWithFadeTransition(context:context, state: state, child: const Market()),
  );

  static final portfolio = RouteModel(
    path: '/portfolio',
    name: 'portfolio',
    pageBuilder: (context, state) =>
        buildPageWithFadeTransition(context:context, state: state, child: const Portfolio()),
  );

  // Onboarding routes
  static final onboarding = RouteModel(
    path: '/onboarding',
    name: 'onboarding',
    builder: (context, state) => const OnboardingStory(),
  );

  static final aiSelect = RouteModel(
    path: 'ai_select',
    name: 'ai_select',
    builder: (context, state) => const AiSelect(),
  );

  // Sub-routes
  static final notifications = RouteModel(
    path: '/notifications',
    name: 'notifications',
    builder: (context, state) => const Notifications(),
  );

  static final settings = RouteModel(
    path: '/settings',
    name: 'settings',
    builder: (context, state) => const Settings(),
  );

  static final automationDetails = RouteModel(
    path: 'automation_details',
    name: 'automation_details',
    builder: (context, state) => const Placeholder(),
  );

  static final newAutomation = RouteModel(
    path: 'new_automation',
    name: 'new_automation',
    builder: (context, state) => const Placeholder(),
  );

  static final search = RouteModel(
    path: 'search',
    name: 'search',
    builder: (context, state) => const Placeholder(),
  );

  static final stockDetails = RouteModel(
    path: 'stock_details',
    name: 'stock_details',
    builder: (context, state) => const Placeholder(),
  );

  static final signInLanding = RouteModel(
    path: 'sign_in_landing',
    name: 'sign_in_landing',
    builder: (context, state) => const SignInLanding(),
  );

  static final signUpLanding = RouteModel(
    path: 'sign_up_landing',
    name: 'sign_up_landing',
    builder: (context, state) => const SignUpLanding(),
  );

  static final signIn = RouteModel(
    path: 'sign_in',
    name: 'sign_in',
    builder: (context, state) => const SignIn(),
  );

  static final signUp = RouteModel(
    path: 'sign_up',
    name: 'sign_up',
    builder: (context, state) => const SignUp(),
  );

  static final signUpVerify = RouteModel(
    path: 'sign_up_verify',
    name: 'sign_up_verify',
    builder: (context, state) => const SignUpVerify(),
  );

  static final resetPassword = RouteModel(
    path: 'reset_password',
    name: 'reset_password',
    builder: (context, state) => const ResetPassword(),
  );
}
