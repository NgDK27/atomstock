import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/pages/authentication/landing/layouts/authentication_landing_layout.dart';

class SignInLanding extends ConsumerWidget {
  const SignInLanding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthenticationLandingLayout(
        title: 'Welcome back',
        navigateAuthenticateWithEmail: () {
          context.goNamed(OpRoutes.signIn.name);
        },
        switchAuthenticationFlowText: "Don't have an account?",
        switchAuthenticationFlowButtonText: 'Get started',
        navigateSwitchAuthenticationFlow: () {
          context.goNamed(OpRoutes.onboarding.name);
        },);
  }
}
