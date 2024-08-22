import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/main_routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';

class OpPlatformSliverTabScaffold extends StatefulHookWidget {
  final Widget child;

  const OpPlatformSliverTabScaffold({super.key, required this.child});

  @override
  State<OpPlatformSliverTabScaffold> createState() => _OpPlatformSliverTabScaffoldState();
}

class _OpPlatformSliverTabScaffoldState extends State<OpPlatformSliverTabScaffold> {
  late final tabController = useMemoized(() => PlatformTabController());

  late final List<BottomNavigationBarItem> _items = useMemoized(() {
    final routes = OpMainRoutes(context);
    return routes.allRoutes.map((route) => BottomNavigationBarItem(
      label: route.label,
      icon: route.icon,
      activeIcon: route.activeIcon,
    ),).toList();
  });

  List<BottomNavigationBarItem> get _itemsFilled {
    final routes = OpMainRoutes(context);
    return routes.allRoutes.map((route) => BottomNavigationBarItem(
      label: route.label,
      icon: route.activeIcon.copyWith(color: OpDynamicColor.onSurfaceVariant(context).withOpacity(OpOpacity.tertiary)),
      activeIcon: route.activeIcon.copyWith(color: OpDynamicColor.primary(context)),
    ),).toList();
  }

  late final _getCurrentIndex = useMemoized(() => (BuildContext context) {
    final state = GoRouterState.of(context);
    final routes = OpMainRoutes(context);
    return routes.allRoutes.indexWhere((route) => state.matchedLocation.startsWith('/${route.route}'));
  },);

  void _onItemTapped(BuildContext context, int index) {
    final routes = OpMainRoutes(context);
    final selectedRoute = routes.allRoutes[index];
    context.goNamed(selectedRoute.route);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      widgetKey: ValueKey(_getCurrentIndex(context)),
      tabController: tabController,
      items: _items,
      bodyBuilder: (context, _) => widget.child,
      itemChanged: (index) => _onItemTapped(context, index),
      material3Tabs: (_, __) => MaterialNavigationBarData(
         ),
      cupertinoTabs: (_, __ ) => CupertinoTabBarData(
        items: _itemsFilled,
        activeColor: OpDynamicColor.primary(context),
      ),
    );
  }
}