import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/widgets/icons/icon_base.dart';

class MainRouteModel {
  final String label;
  final IconBase icon;
  final IconBase activeIcon;
  final String route;
  final WidgetBuilder builder;


  const MainRouteModel({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    required this.builder,
  });
}