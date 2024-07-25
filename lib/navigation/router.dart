import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_tab_scaffold.dart';

class OpRouter {
  OpRouter._();

  static final router = GoRouter(
    initialLocation: '/market/stock_details',
    routes: [
      OpRoutes.onboarding.route(
        routes: [
          OpRoutes.signInLanding.route(routes: [
            OpRoutes.signIn.route(routes: [OpRoutes.resetPassword.route()]),
          ],),
          OpRoutes.aiSelect.route(
            routes: [
              OpRoutes.signUpLanding.route(routes: [
                OpRoutes.signUp.route(routes: [OpRoutes.signUpVerify.route()]),
              ],),
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
              OpRoutes.stockDetails.route(),
            ],
          ),
          OpRoutes.portfolio.route(),
        ],
      ),
      OpRoutes.settings.route(),
      OpRoutes.notifications.route(),
    ],
  );
}
