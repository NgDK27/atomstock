import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/navigation/models/main_route_model.dart';
import 'package:oppenhomies/navigation/routes.dart';
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
    );
    ai = MainRouteModel(
      label: 'AI',
      icon: const SparkleOutlined(),
      activeIcon: const SparkleFilled(),
      route: OpRoutes.ai.name,
    );
    automations = MainRouteModel(
      label: 'Automations',
      icon: const LightningOutlined(),
      activeIcon: const LightningFilled(),
      route: OpRoutes.automations.name,
    );
    market = MainRouteModel(
      label: 'Explore',
      icon: const CompassOutlined(),
      activeIcon: const CompassFilled(),
      route: OpRoutes.market.name,
    );
    portfolio = MainRouteModel(
      label: 'Portfolio',
      icon: const SuitcaseOutlined(),
      activeIcon: const SuitcaseFilled(),
      route: OpRoutes.portfolio.name,
    );
    settings = MainRouteModel(
      label: 'Settings',
      icon: const GearOutlined(),
      activeIcon: const GearFilled(),
      route: OpRoutes.settings.name,
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
