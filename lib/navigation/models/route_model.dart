import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RouteModel {
  final String path;
  final String name;
  final Widget Function(BuildContext, GoRouterState)? builder;
  final Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder;

  const RouteModel({
    required this.path,
    required this.name,
    this.builder,
    this.pageBuilder
  });

  GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: name,
    pageBuilder: pageBuilder,
    builder: (context, state) => builder!(context, state),
    routes: routes,
  );
}