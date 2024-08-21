import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_tab_scaffold.dart';

class OpRouter {
  OpRouter._();

  static final router = GoRouter(
    initialLocation: OpRoutes.market.path,
    routes: [
      OpRoutes.onboarding.route(
        routes: [
          OpRoutes.signInLanding.route(
            routes: [
              OpRoutes.signIn.route(routes: [OpRoutes.resetPassword.route()]),
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
          return OpPlatformSliverTabScaffold(child: child);
        },
        routes: [
          OpRoutes.home.route(),
          OpRoutes.ai.route(

          ),
          OpRoutes.automations.route(
            routes: [
              OpRoutes.automationDetails.route(),
              OpRoutes.newAutomation.route(),
            ],
          ),
          OpRoutes.market.route(
            routes: [
              OpRoutes.search.route(),
              OpRoutes.stockDetails.route(),
            ],
          ),
          OpRoutes.portfolio.route(),
          OpRoutes.settings.route(
            routes: [
              OpRoutes.connectedAccounts.route(),
              OpRoutes.yourName.route(),
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
                      OpRoutes.updatePasswordCompleted.route(
                      ),
                    ],
                  ),
                ],
              ),
              OpRoutes.thirdPartySignIn.route(),
              OpRoutes.appearance.route(),
              OpRoutes.language.route(),
              OpRoutes.faq.route(),
              OpRoutes.contactSupport.route(),
            ],
          ),
        ],
      ),
      OpRoutes.notifications.route(),
      OpRoutes.addFunds.route(),
      OpRoutes.withdrawFunds.route(),
    ],
  );
}
