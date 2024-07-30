import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsDestination {
  final String title;
  final String route;
  final IconData materialIcon;
  final IconData cupertinoIcon;

  const SettingsDestination({
    required this.title,
    required this.route,
    required this.materialIcon,
    required this.cupertinoIcon,
  });
}