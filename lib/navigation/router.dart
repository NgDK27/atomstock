import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/providers/auth/auth_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_tab_scaffold.dart';

class OpRouter {
  OpRouter._();

  static router(WidgetRef ref) => GoRouter(
        initialLocation: OpRoutes.onboarding.path,
        redirect: (BuildContext context, GoRouterState state) async {
          final authNotifier = ref.read(authProvider.notifier);
          final isSignedIn = await authNotifier.isSignedIn();
          final isOnboardingRoute =
              state.matchedLocation.startsWith(OpRoutes.onboarding.path);

          if (!isSignedIn && !isOnboardingRoute) {
            return OpRoutes.onboarding.path;
          } else if (isSignedIn && isOnboardingRoute) {
            return OpRoutes.home.path;
          }
          return null;
        },
        routes: [
          OpRoutes.onboarding.route(
            routes: [
              OpRoutes.signInLanding.route(
                routes: [
                  OpRoutes.signIn
                      .route(routes: [OpRoutes.resetPassword.route()]),
                ],
              ),
              OpRoutes.aiSelect.route(
                routes: [
                  OpRoutes.signUpLanding.route(
                    routes: [
                      OpRoutes.signUp
                          .route(routes: [OpRoutes.signUpVerify.route()]),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) {
              return OpPlatformSliverTabScaffold(
                child: child,
              );
            },
            routes: [
              OpRoutes.home.route(),
              OpRoutes.ai.route(),
              OpRoutes.automations.route(
                routes: [
                  OpRoutes.automationDetails.route(),
                  OpRoutes.newAutomation.route(),
                ],
              ),
              OpRoutes.market.route(
                routes: [
                  OpRoutes.search.route(),
                ],
              ),
              OpRoutes.portfolio.route(),
              OpRoutes.settings.route(),
              OpRoutes.indexes.route(),
              OpRoutes.topPerformers.route(),
              OpRoutes.topDecliners.route(),
              OpRoutes.topMovers.route(),
              OpRoutes.notifications.route(),
              OpRoutes.stockDetails.route(),
            ],
          ),
          OpRoutes.addFunds.route(),
          OpRoutes.withdrawFunds.route(),
          OpRoutes.connectedAccounts.route(),
          OpRoutes.yourName.route(),
          OpRoutes.thirdPartySignIn.route(),
          OpRoutes.appearance.route(),
          OpRoutes.language.route(),
          OpRoutes.faq.route(),
          OpRoutes.contactSupport.route(),
          OpRoutes.verifyCurrentEmail.route(
            routes: [
              OpRoutes.inputNewEmail.route(
                routes: [
                  OpRoutes.verifyNewEmail.route(
                    routes: [OpRoutes.updateEmailCompleted.route()],
                  ),
                ],
              ),
            ],
          ),
          OpRoutes.verifyCurrentPassword.route(
            routes: [
              OpRoutes.inputNewPassword.route(
                routes: [
                  OpRoutes.updatePasswordCompleted.route(),
                ],
              ),
            ],
          ),
        ],
      );
}
