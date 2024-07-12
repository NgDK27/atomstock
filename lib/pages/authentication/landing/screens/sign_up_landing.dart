import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/pages/authentication/landing/layouts/authentication_landing_layout.dart';

class SignUpLanding extends ConsumerWidget {
  const SignUpLanding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthenticationLandingLayout(
        title: 'One last step',
        showSupportingText: true,
        supportingStartText: 'Create an account and start investing with your chosen AI Advisor, ',
        supportingEndText: 'Slow and Steady',
        navigateAuthenticateWithEmail: () {
          context.goNamed(OpRoutes.signUp.name);
        },
        switchAuthenticationFlowText: "Already have an account?",
        switchAuthenticationFlowButtonText: 'Sign in',
        navigateSwitchAuthenticationFlow: () =>
            context.goNamed(OpRoutes.signInLanding.name),
    showSignInAlertDialog: true,);
  }
}
