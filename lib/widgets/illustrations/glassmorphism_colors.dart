import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/widgets/helpers/colors_tint_with.dart';

import '../../styles/colors.dart';
import 'glassmorphism_base.dart';

mixin GlassmorphismColorMixin<T extends GlassmorphismIllustration> {
  T withDynamicColors(BuildContext context) {
    return this.copyWith(
      overlayBeginColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.primaryContainer,
        cupertino: (_) => (this as T).overlayBeginColor,
      ),
      overlayEndColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.tertiaryFixed,
        cupertino: (_) => (this as T).overlayEndColor,
      ),
      underlyingBeginColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.primary,
        cupertino: (_) => (this as T).underlyingBeginColor,
      ),
      underlyingEndColor: platformThemeData(
        context,
        material: (ThemeData data) => data.colorScheme.tertiaryContainer,
        cupertino: (_) => (this as T).underlyingEndColor,
      ),
      overlayBorderColor: platformThemeData(
        context,
        material: (ThemeData data) => OpColor.mono100.tintWithPrimary(context),
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