import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/main_routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';

class OpPlatformSliverTabScaffold extends HookWidget {
  final Widget child;

  const OpPlatformSliverTabScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final tabController = useMemoized(() => PlatformTabController());

    final routes = useMemoized(() => OpMainRoutes(context));

    final items = useMemoized(() => routes.allRoutes.map((route) => BottomNavigationBarItem(
      label: route.label,
      icon: route.icon,
      activeIcon: route.activeIcon,
    ),).toList(),);

    final itemsFilled = useMemoized(() => routes.allRoutes.map((route) => BottomNavigationBarItem(
      label: route.label,
      icon: route.activeIcon.copyWith(color: OpDynamicColor.onSurfaceVariant(context).withOpacity(OpOpacity.tertiary)),
      activeIcon: route.activeIcon.copyWith(color: OpDynamicColor.primary(context)),
    ),).toList(),);

    int getCurrentIndex(BuildContext context) {
      final state = GoRouterState.of(context);
      return routes.allRoutes.indexWhere((route) => state.matchedLocation.startsWith('/${route.route}'));
    }

    void onItemTapped(BuildContext context, int index) {
      final selectedRoute = routes.allRoutes[index];
      context.goNamed(selectedRoute.route);
    }

    return PlatformTabScaffold(
      widgetKey: ValueKey(getCurrentIndex(context)),
      tabController: tabController,
      items: items,
      bodyBuilder: (context, _) => child,
      itemChanged: (index) => onItemTapped(context, index),
      material3Tabs: (_, __) => MaterialNavigationBarData(),
      cupertinoTabs: (_, __) => CupertinoTabBarData(
        items: itemsFilled,
        activeColor: OpDynamicColor.primary(context),
      ),
    );
  }
}