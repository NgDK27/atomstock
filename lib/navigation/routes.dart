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
import 'package:oppenhomies/pages/funds/add_funds/screens/add_funds.dart';
import 'package:oppenhomies/pages/funds/withdraw_funds/screens/withdraw_funds.dart';
import 'package:oppenhomies/pages/home/screens/home.dart';
import 'package:oppenhomies/pages/market/screens/market.dart';
import 'package:oppenhomies/pages/market/stock_details/screens/stock_details_tab_scaffold.dart';
import 'package:oppenhomies/pages/notifications/screens/notifications.dart';
import 'package:oppenhomies/pages/onboarding/ai_select/screens/ai_select.dart';
import 'package:oppenhomies/pages/onboarding/story/screens/onboarding_story.dart';
import 'package:oppenhomies/pages/portfolio/screens/portfolio.dart';
import 'package:oppenhomies/pages/settings/appearance/screens/appearance.dart';
import 'package:oppenhomies/pages/settings/connected_accounts/connected_accounts.dart';
import 'package:oppenhomies/pages/settings/contact_support/screens/contact_support.dart';
import 'package:oppenhomies/pages/settings/faq/screens/faq.dart';
import 'package:oppenhomies/pages/settings/language/screens/appearance.dart';
import 'package:oppenhomies/pages/settings/settings/screens/settings.dart';
import 'package:oppenhomies/pages/settings/update_email/input_new_email.dart';
import 'package:oppenhomies/pages/settings/update_email/update_email_completed.dart';
import 'package:oppenhomies/pages/settings/update_email/verify_current_email.dart';
import 'package:oppenhomies/pages/settings/update_email/verify_new_email.dart';
import 'package:oppenhomies/pages/settings/your_name/screens/your_name.dart';

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
    pageBuilder: (context, state) => buildPageWithFadeTransition(
        context: context, state: state, child: const Home()),
  );

  static final ai = RouteModel(
    path: '/ai',
    name: 'ai',
    pageBuilder: (context, state) => buildPageWithFadeTransition(
        context: context, state: state, child: const Ai()),
  );

  static final automations = RouteModel(
    path: '/automations',
    name: 'automations',
    pageBuilder: (context, state) => buildPageWithFadeTransition(
        context: context, state: state, child: const Automations()),
  );

  static final market = RouteModel(
    path: '/market',
    name: 'market',
    pageBuilder: (context, state) => buildPageWithFadeTransition(
        context: context, state: state, child: const Market()),
  );

  static final portfolio = RouteModel(
    path: '/portfolio',
    name: 'portfolio',
    pageBuilder: (context, state) => buildPageWithFadeTransition(
        context: context, state: state, child: const Portfolio()),
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
    builder: (context, state) => const StockDetails(),
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

  // region Settings sub-routes
  static final addFunds = RouteModel(
    path: '/add_funds',
    name: 'add_funds',
    builder: (context, state) => const AddFunds(), // Replace with actual widget
  );

  static final withdrawFunds = RouteModel(
    path: '/withdraw_funds',
    name: 'withdraw_funds',
    builder: (context, state) =>
        const WithdrawFunds(), // Replace with actual widget
  );

  static final connectedAccounts = RouteModel(
    path: 'connected_accounts',
    name: 'connected_accounts',
    builder: (context, state) =>
        const ConnectedAccounts(), // Replace with actual widget
  );

  static final yourName = RouteModel(
    path: 'your_name',
    name: 'your_name',
    builder: (context, state) => const YourName(), // Replace with actual widget
  );

  static final verifyCurrentEmail = RouteModel(
    path: 'verify_current_email',
    name: 'verify_current_email',
    builder: (context, state) => const VerifyCurrentEmail(),
  );

  static final inputNewEmail = RouteModel(
    path: 'input_new_email',
    name: 'input_new_email',
    builder: (context, state) => const InputNewEmail(),
  );

  static final verifyNewEmail = RouteModel(
    path: 'verify_new_email',
    name: 'verify_new_email',
    builder: (context, state) => const VerifyNewEmail(),
  );

  static final updateEmailCompleted = RouteModel(
    path: 'update_email_completed',
    name: 'update_email_completed',
    builder: (context, state) => const UpdateEmailCompleted(),
  );

  static final updatePassword = RouteModel(
    path: 'update_password',
    name: 'update_password',
    builder: (context, state) =>
        const Placeholder(), // Replace with actual widget
  );

  static final thirdPartySignIn = RouteModel(
    path: 'third_party_sign_in',
    name: 'third_party_sign_in',
    builder: (context, state) =>
        const Placeholder(), // Replace with actual widget
  );

  static final appearance = RouteModel(
    path: 'appearance',
    name: 'appearance',
    builder: (context, state) =>
        const Appearance(), // Replace with actual widget
  );

  static final language = RouteModel(
    path: 'language',
    name: 'language',
    builder: (context, state) => const Language(), // Replace with actual widget
  );

  static final faq = RouteModel(
    path: 'faq',
    name: 'faq',
    builder: (context, state) => const Faq(), // Replace with actual widget
  );

  static final contactSupport = RouteModel(
    path: 'contact_support',
    name: 'contact_support',
    builder: (context, state) =>
        const ContactSupport(), // Replace with actual widget
  );
// endregion
}
