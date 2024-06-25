import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'glassmorphism_base.dart';

mixin GlassmorphismColorMixin<T extends GlassmorphismIllustration> {
  T withDynamicColors(BuildContext context) {
    return this.copyWith(
      overlayBeginColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.primary,
        cupertino: (_) => (this as T).overlayBeginColor,
      ),
      overlayEndColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.tertiary,
        cupertino: (_) => (this as T).overlayEndColor,
      ),
      underlyingBeginColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.primary,
        cupertino: (_) => (this as T).underlyingBeginColor,
      ),
      underlyingEndColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.tertiary,
        cupertino: (_) => (this as T).underlyingEndColor,
      ),
      overlayBorderColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.onPrimaryContainer,
        cupertino: (_) => (this as T).overlayBorderColor,
      ),
    );
  }

  T copyWith({
    Color? overlayBeginColor,
    Color? overlayEndColor,
    Color? underlyingBeginColor,
    Color? underlyingEndColor,
    Color? overlayBorderColor,
  });
}