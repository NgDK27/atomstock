import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/cupertino_theme.dart';
import 'package:oppenhomies/styles/fonts.dart';

import 'navigation/router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: OppenhomiesApp(),
    ),
  );
}

class OppenhomiesApp extends ConsumerWidget {
  const OppenhomiesApp({super.key});

  // TODO: Remove once flutter_dynamic_colors is fixed
  (ColorScheme light, ColorScheme dark) _generateDynamicColourSchemes(
    ColorScheme lightDynamic,
    ColorScheme darkDynamic,
  ) {
    var lightBase = ColorScheme.fromSeed(seedColor: lightDynamic.primary);
    var darkBase = ColorScheme.fromSeed(
      seedColor: darkDynamic.primary,
      brightness: Brightness.dark,
    );
    var lightAdditionalColours = _extractAdditionalColours(lightBase);
    var darkAdditionalColours = _extractAdditionalColours(darkBase);
    var lightScheme =
        _insertAdditionalColours(lightBase, lightAdditionalColours);
    var darkScheme = _insertAdditionalColours(darkBase, darkAdditionalColours);
    return (lightScheme.harmonized(), darkScheme.harmonized());
  }

  List<Color> _extractAdditionalColours(ColorScheme scheme) => [
        scheme.surface,
        scheme.surfaceDim,
        scheme.surfaceBright,
        scheme.surfaceContainerLowest,
        scheme.surfaceContainerLow,
        scheme.surfaceContainer,
        scheme.surfaceContainerHigh,
        scheme.surfaceContainerHighest,
      ];

  ColorScheme _insertAdditionalColours(
    ColorScheme scheme,
    List<Color> additionalColours,
  ) =>
      scheme.copyWith(
        surface: additionalColours[0],
        surfaceDim: additionalColours[1],
        surfaceBright: additionalColours[2],
        surfaceContainerLowest: additionalColours[3],
        surfaceContainerLow: additionalColours[4],
        surfaceContainer: additionalColours[5],
        surfaceContainerHigh: additionalColours[6],
        surfaceContainerHighest: additionalColours[7],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Edge-to-edge
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return PlatformProvider(
      builder: (context) =>

          // TODO: Replace once flutter_dynamic_colors is fixed
          // TEMPORARY FIX because flutter_dynamic_colors are not generating all colors
          DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme? lightScheme, darkScheme;

          if (lightDynamic != null && darkDynamic != null) {
            (lightScheme, darkScheme) =
                _generateDynamicColourSchemes(lightDynamic, darkDynamic);
          } else {
            lightScheme = lightDynamic;
            darkScheme = darkDynamic;
          }
          // CORRECT VERSION from documentation
          // DynamicColorBuilder(
          // builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic)

          return PlatformTheme(
            themeMode: ThemeMode.system,
            materialLightTheme: ThemeData(
              colorScheme: lightScheme,
              textTheme: opMaterialTextTheme,
            ),
            materialDarkTheme: ThemeData(
              colorScheme: darkScheme,
              textTheme: opMaterialTextTheme,
            ),
            cupertinoLightTheme: opCupertinoLightTheme,
            cupertinoDarkTheme: opCupertinoDarkTheme,
            builder: (context) => PlatformApp.router(
              title: 'Atomstock',
              routerConfig: OpRouter.router,
              debugShowCheckedModeBanner: false,
              // Hide "Debug" banner
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }
}
