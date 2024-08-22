import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class OpTextStyle {
  OpTextStyle._();

  static TextStyle bold([TextStyle? style]) {
    return (style ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle regular([TextStyle? style]) {
    return (style ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle spacedOut([TextStyle? style]) {
    return (style ?? const TextStyle()).copyWith(
      letterSpacing: 1,
    );
  }

  static TextStyle? display(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.displaySmall,
    cupertino: (data) => data.textTheme.navLargeTitleTextStyle,
  );

  static TextStyle? headline(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.headlineSmall,
    cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: (data.textTheme.navTitleTextStyle.fontSize ?? 17) * 1.2,
    ),
  );

  static TextStyle? titleLarge(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.titleLarge,
    cupertino: (data) => data.textTheme.textStyle.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: (data.textTheme.textStyle.fontSize ?? 17) * 1.176,
    ),
  );

  static TextStyle? titleMedium(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.titleMedium,
    cupertino: (data) => data.textTheme.textStyle.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: (data.textTheme.textStyle.fontSize ?? 17) * 1.15,
    ),
  );

  static TextStyle? titleSmall(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.titleSmall,
    cupertino: (data) => data.textTheme.textStyle.bold(),
  );

  static TextStyle? bodyLarge(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.bodyLarge,
    cupertino: (data) => data.textTheme.textStyle.bold(),
  );

  static TextStyle? body(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.bodyMedium,
    cupertino: (data) => data.textTheme.textStyle,
  );

  static TextStyle? labelLarge(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.labelLarge,
    cupertino: (data) => data.textTheme.textStyle.copyWith(
      letterSpacing: 0.1,
      fontSize: (data.textTheme.textStyle.fontSize ?? 17) * 0.88,
    ),
  );

  static TextStyle? labelMedium(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.labelMedium,
    cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(
      fontSize: (data.textTheme.tabLabelTextStyle.fontSize ?? 10) * 1.3,
    ),
  );

  static TextStyle? labelSmall(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.labelSmall,
    cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(
      fontSize: (data.textTheme.tabLabelTextStyle.fontSize ?? 10) * 1.1,
    ),
  );

  static TextStyle? labelMediumProminent(BuildContext context) => _getStyle(
    context,
    material: (data) => data.textTheme.labelMedium,
    cupertino: (data) => data.textTheme.tabLabelTextStyle.copyWith(
      fontSize: (data.textTheme.tabLabelTextStyle.fontSize ?? 10) * 1.3,
      letterSpacing: 0.8,
    ),
  );

  static TextStyle? _getStyle(
      BuildContext context, {
        required TextStyle? Function(ThemeData) material,
        required TextStyle? Function(CupertinoThemeData) cupertino,
      }) {
    return platformThemeData(
      context,
      material: material,
      cupertino: cupertino,
    )?.copyWith(
      inherit: true,
    );
  }
}

extension TextStyleExtensions on TextStyle? {
  TextStyle bold() {
    return OpTextStyle.bold(this);
  }

  TextStyle regular() {
    return OpTextStyle.regular(this);
  }

  TextStyle spacedOut() {
    return OpTextStyle.spacedOut(this);
  }
}
