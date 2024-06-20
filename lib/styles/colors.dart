import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/opacities.dart';

class OpDynamicColor {
  OpDynamicColor._();

  // Functions
  static Brightness get _platformBrightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  static bool get _isLightMode => _platformBrightness == Brightness.light;

  static Color _getDynamicColor(Color lightColor, Color darkColor) =>
      _isLightMode ? lightColor : darkColor;

  // Primary
  static const Color _primaryLight = OpColor.aqua140;
  static const Color _primaryDark = OpColor.aqua100;
  static Color get primary => _getDynamicColor(_primaryLight, _primaryDark);

  static final Color _primarySecondaryLight = OpColor.aqua140.withAlpha(OpOpacity.secondary);
  static final Color _primarySecondaryDark = OpColor.aqua100.withAlpha(OpOpacity.secondary);
  static Color get primarySecondary => _getDynamicColor(_primarySecondaryLight, _primarySecondaryDark);

  static final Color _primaryQuarternaryLight = OpColor.aqua140.withAlpha(OpOpacity.quaternary);
  static final Color _primaryQuarternaryDark = OpColor.aqua100.withAlpha(OpOpacity.quaternary);
  static Color get primaryQuarternary => _getDynamicColor(_primaryQuarternaryLight, _primaryQuarternaryDark);

  // Stock
  static const Color _stockFallLight = OpColor.cherry120;
  static const Color _stockFallDark = OpColor.cherry80;
  static Color get stockFall => _getDynamicColor(_stockFallLight, _stockFallDark);

  static const Color _stockRiseLight = OpColor.aqua120;
  static const Color _stockRiseDark = OpColor.aqua80;
  static Color get stockRise => _getDynamicColor(_stockRiseLight, _stockRiseDark);

  static final Color _stockFallGradientInLight = OpColor.cherry120.withAlpha(102);
  static final Color _stockFallGradientInDark = OpColor.cherry80.withAlpha(102);
  static Color get stockFallGradientIn => _getDynamicColor(_stockFallGradientInLight, _stockFallGradientInDark);

  static final Color _stockRiseGradientInLight = OpColor.aqua120.withAlpha(102);
  static final Color _stockRiseGradientInDark = OpColor.aqua80.withAlpha(102);
  static Color get stockRiseGradientIn => _getDynamicColor(_stockRiseGradientInLight, _stockRiseGradientInDark);

  static final Color _stockFallGradientOutLight = OpColor.cherry120.withAlpha(OpOpacity.none);
  static final Color _stockFallGradientOutDark = OpColor.cherry80.withAlpha(OpOpacity.none);
  static Color get stockFallGradientOut => _getDynamicColor(_stockFallGradientOutLight, _stockFallGradientOutDark);

  static final Color _stockRiseGradientOutLight = OpColor.aqua120.withAlpha(OpOpacity.none);
  static final Color _stockRiseGradientOutDark = OpColor.aqua80.withAlpha(OpOpacity.none);
  static Color get stockRiseGradientOut => _getDynamicColor(_stockRiseGradientOutLight, _stockRiseGradientOutDark);

  // AI
  static final Color _aiGradientInLight = OpColor.grape120.withAlpha(102);
  static final Color _aiGradientInDark = OpColor.grape80.withAlpha(102);
  static Color get aiGradientIn => _getDynamicColor(_aiGradientInLight, _aiGradientInDark);

  static final Color _aiGradientOutLight = OpColor.grape120.withAlpha(OpOpacity.none);
  static final Color _aiGradientOutDark = OpColor.grape80.withAlpha(OpOpacity.none);
  static Color get aiGradientOut => _getDynamicColor(_aiGradientOutLight, _aiGradientOutDark);

  static const Color _aiLight = OpColor.grape120;
  static const Color _aiDark = OpColor.grape60;
  static Color get ai => _getDynamicColor(_aiLight, _aiDark);

  // Error
  static const Color _errorLight = OpColor.cherry120;
  static const Color _errorDark = OpColor.cherry40;
  static Color get error => _getDynamicColor(_errorLight, _errorDark);

  // Surfaces
  static const Color _surfaceLight = OpColor.mono100;
  static const Color _surfaceDark = OpColor.charcoal120;
  static Color get surface => _getDynamicColor(_surfaceLight, _surfaceDark);

  static const Color _surfaceInverseLight = OpColor.charcoal120;
  static const Color _surfaceInverseDark = OpColor.mono100;
  static Color get surfaceInverse => _getDynamicColor(_surfaceInverseLight, _surfaceInverseDark);

  static final Color _surfaceSecondaryLight = OpColor.charcoal120.withAlpha(OpOpacity.secondary);
  static final Color _surfaceSecondaryDark = OpColor.charcoal20.withAlpha(OpOpacity.tertiary);
  static Color get surfaceSecondary => _getDynamicColor(_surfaceSecondaryLight, _surfaceSecondaryDark);

  static final Color _surfaceQuarternaryLight = OpColor.charcoal120.withAlpha(OpOpacity.quaternary);
  static final Color _surfaceQuarternaryDark = OpColor.charcoal20.withAlpha(OpOpacity.quaternary);
  static Color get surfaceQuarternary => _getDynamicColor(_surfaceQuarternaryLight, _surfaceQuarternaryDark);

  static const Color _surfaceVariantLight = OpColor.mono99;
  static const Color _surfaceVariantDark = OpColor.mono10;
  static Color get surfaceVariant => _getDynamicColor(_surfaceVariantLight, _surfaceVariantDark);

  // On Surfaces
  static const Color _onSurfaceLight = OpColor.charcoal120;
  static const Color _onSurfaceDark = OpColor.mono100;
  static Color get onSurface => _getDynamicColor(_onSurfaceLight, _onSurfaceDark);

  static const Color _onSurfaceVariantLight = OpColor.charcoal100;
  static const Color _onSurfaceVariantDark = OpColor.mono99;
  static Color get onSurfaceVariant => _getDynamicColor(_onSurfaceVariantLight, _onSurfaceVariantDark);

  static const Color _onSurfacePrimaryLight = OpColor.mono100;
  static const Color _onSurfacePrimaryDark = OpColor.charcoal120;
  static Color get onSurfacePrimary => _getDynamicColor(_onSurfacePrimaryLight, _onSurfacePrimaryDark);

  static const Color _onSurfaceInverseLight = OpColor.mono100;
  static const Color _onSurfaceInverseDark = OpColor.charcoal120;
  static Color get onSurfaceInverse => _getDynamicColor(_onSurfaceInverseLight, _onSurfaceInverseDark);

  static const Color _onSurfaceStrokesLight = OpColor.charcoal100;
  static const Color _onSurfaceStrokesDark = OpColor.mono95;
  static Color get onSurfaceStrokes => _getDynamicColor(_onSurfaceStrokesLight, _onSurfaceStrokesDark);

  static const Color _onSurfaceVariantStrokesLight = OpColor.mono95;
  static const Color _onSurfaceVariantStrokesDark = OpColor.mono50;
  static Color get onSurfaceVariantStrokes => _getDynamicColor(_onSurfaceVariantStrokesLight, _onSurfaceVariantStrokesDark);

  static const Color _onSurfaceNeutralContainerLight = _onSurfaceLight;
  static const Color _onSurfaceNeutralContainerDark = _onSurfaceDark;
  static Color get onSurfaceNeutralContainer => _getDynamicColor(_onSurfaceNeutralContainerLight, _onSurfaceNeutralContainerDark);

  static const Color _onSurfacePrimaryContainerLight = OpColor.aqua140;
  static const Color _onSurfacePrimaryContainerDark = OpColor.aqua60;
  static Color get onSurfacePrimaryContainer => _getDynamicColor(_onSurfacePrimaryContainerLight, _onSurfacePrimaryContainerDark);

  // Containers
  static const Color _containerNeutralLv1Light = OpColor.mono98;
  static const Color _containerNeutralLv1Dark = OpColor.mono40;
  static Color get containerNeutralLv1 => _getDynamicColor(_containerNeutralLv1Light, _containerNeutralLv1Dark);

  static const Color _containerNeutralLv2Light = OpColor.mono100;
  static const Color _containerNeutralLv2Dark = OpColor.mono60;
  static Color get containerNeutralLv2 => _getDynamicColor(_containerNeutralLv2Light, _containerNeutralLv2Dark);

  static const Color _primaryContainerLight = OpColor.aqua60;
  static const Color _primaryContainerDark = OpColor.aqua140;
  static Color get primaryContainer => _getDynamicColor(_primaryContainerLight, _primaryContainerDark);

  static final Color _secondaryContainerLight = OpColor.aqua80.withAlpha(OpOpacity.tertiary);
  static final Color _secondaryContainerDark = OpColor.aqua140.withAlpha(OpOpacity.tertiary);
  static Color get secondaryContainer => _getDynamicColor(_secondaryContainerLight, _secondaryContainerDark);
}

class OpColor {
  OpColor._();

  // charcoal
  static const Color charcoal20 = Color(0xFF808793);
  static const Color charcoal60 = Color(0xFF525866);
  static const Color charcoal80 = Color(0xFF383F4C);
  static const Color charcoal100 = Color(0xFF212630);
  static const Color charcoal120 = Color(0xFF14161A);

  // sky
  static const Color sky40 = Color(0xFFE1EDEF);
  static const Color sky60 = Color(0xFFD1E2E6);
  static const Color sky80 = Color(0xFFC0D8DD);
  static const Color sky100 = Color(0xFFB0CED4);
  static const Color sky120 = Color(0xFF88B6BF);

  // grape
  static const Color grape10 = Color(0xFFEDE7FE);
  static const Color grape60 = Color(0xFFA586F4);
  static const Color grape80 = Color(0xFF7C4BF6);
  static const Color grape100 = Color(0xFF4A0BE8);
  static const Color grape120 = Color(0xFF3308A1);
  static const Color grape140 = Color(0xFF160344);

  // cherry
  static const Color cherry40 = Color(0xFFFF8AB3);
  static const Color cherry60 = Color(0xFFFF5792);
  static const Color cherry80 = Color(0xFFFF0A60);
  static const Color cherry100 = Color(0xFFE0004E);
  static const Color cherry120 = Color(0xFFC10647);
  static const Color cherry140 = Color(0xFF77042C);

  // aqua
  static const Color aqua10 = Color(0xFFEBFFFF);
  static const Color aqua60 = Color(0xFFCCFFFE);
  static const Color aqua80 = Color(0xFF66FFFC);
  static const Color aqua100 = Color(0xFF00F5FA);
  static const Color aqua120 = Color(0xFF00DCE0);
  static const Color aqua140 = Color(0xFF00AFB3);

  // lemon
  static const Color lemon10 = Color(0xFFFFF1BD);
  static const Color lemon60 = Color(0xFFFFE78F);
  static const Color lemon80 = Color(0xFFFFD84C);
  static const Color lemon100 = Color(0xFFFDC600);
  static const Color lemon120 = Color(0xFFE6B400);

  // mono
  static const Color mono0 = Color(0xFF000000);
  static const Color mono10 = Color(0xFF020202);
  static const Color mono40 = Color(0xFF363636);
  static const Color mono50 = Color(0xFF4C4C4C);
  static const Color mono60 = Color(0xFF636363);
  static const Color mono95 = Color(0xFFC8C8C8);
  static const Color mono98 = Color(0xFFE7E7E7);
  static const Color mono99 = Color(0xFFFAFAFA);
  static const Color mono100 = Color(0xFFFFFFFF);
}