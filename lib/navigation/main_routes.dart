import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/navigation/models/main_route_model.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/pages/ai/screens/ai.dart';
import 'package:oppenhomies/pages/automations/screens/automations.dart';
import 'package:oppenhomies/pages/home/screens/home.dart';
import 'package:oppenhomies/pages/market/screens/market.dart';
import 'package:oppenhomies/pages/portfolio/screens/portfolio.dart';
import 'package:oppenhomies/pages/settings/settings/screens/settings.dart';
import 'package:oppenhomies/widgets/icons/compass_filled.dart';
import 'package:oppenhomies/widgets/icons/compass_outlined.dart';
import 'package:oppenhomies/widgets/icons/gear_filled.dart';
import 'package:oppenhomies/widgets/icons/gear_outlined.dart';
import 'package:oppenhomies/widgets/icons/home_filled.dart';
import 'package:oppenhomies/widgets/icons/home_outlined.dart';
import 'package:oppenhomies/widgets/icons/lightning_filled.dart';
import 'package:oppenhomies/widgets/icons/lightning_outlined.dart';
import 'package:oppenhomies/widgets/icons/sparkle_filled.dart';
import 'package:oppenhomies/widgets/icons/sparkle_outlined.dart';
import 'package:oppenhomies/widgets/icons/suitcase_filled.dart';
import 'package:oppenhomies/widgets/icons/suitcase_outlined.dart';

class OpMainRoutes {
  final BuildContext context;
  late final MainRouteModel home;
  late final MainRouteModel ai;
  late final MainRouteModel automations;
  late final MainRouteModel market;
  late final MainRouteModel portfolio;
  late final MainRouteModel settings;

  OpMainRoutes(this.context) {
    home = MainRouteModel(
      label: 'Home',
      icon: const HomeOutlined(),
      activeIcon: const HomeFilled(),
      route: OpRoutes.home.name,
      builder: (context) => const Home(),
    );
    ai = MainRouteModel(
      label: 'AI',
      icon: const SparkleOutlined(),
      activeIcon: const SparkleFilled(),
      route: OpRoutes.ai.name,
      builder: (context) => const Ai(),
    );
    automations = MainRouteModel(
      label: 'Automations',
      icon: const LightningOutlined(),
      activeIcon: const LightningFilled(),
      route: OpRoutes.automations.name,
      builder: (context) => const Automations(),
    );
    market = MainRouteModel(
      label: 'Explore',
      icon: const CompassOutlined(),
      activeIcon: const CompassFilled(),
      route: OpRoutes.market.name,
      builder: (context) => const Market(),
    );
    portfolio = MainRouteModel(
      label: 'Portfolio',
      icon: const SuitcaseOutlined(),
      activeIcon: const SuitcaseFilled(),
      route: OpRoutes.portfolio.name,
      builder: (context) => const Portfolio(),
    );
    settings = MainRouteModel(
      label: 'Settings',
      icon: const GearOutlined(),
      activeIcon: const GearFilled(),
      route: OpRoutes.settings.name,
      builder: (context) => const Settings(),
    );
  }

  List<MainRouteModel> get allRoutes =>
      [home,
        ai,
        // automations,
        market,
        portfolio,
        settings,
      ];
}
