import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:oppenhomies/pages/home_screen/screens/home_screen.dart';
// import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) =>
    const ProviderScope(
      child: OppenhomiesApp(),
    ),
    // )
  );
}

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class OppenhomiesApp extends ConsumerWidget {
  const OppenhomiesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Edge-to-edge
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Text Theme
    const interFontFeatures = <FontFeature>[
      FontFeature.enable('tnum'),
      FontFeature.enable('opsz'),
      FontFeature.enable('cv01'),
      FontFeature.enable('cv02'),
      FontFeature.enable('cv03'),
      FontFeature.enable('cv04'),
      FontFeature.enable('cv06'),
      FontFeature.enable('cv09'),
      FontFeature.enable('cv10'),
      FontFeature.enable('cv11'),
      FontFeature.enable('cv12'),
    ];
    const interTextTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      displayMedium: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      displaySmall: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      headlineLarge: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      titleLarge: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      titleMedium: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      titleSmall: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      bodySmall: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      labelLarge: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      labelMedium: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
      labelSmall: TextStyle(
        fontFamily: "Inter",
        fontFeatures: interFontFeatures,
      ),
    );

    // Cupertino Theme Declaration
    const lightDefaultCupertinoTheme = CupertinoThemeData();
    const darkDefaultCupertinoTheme =
        CupertinoThemeData(brightness: Brightness.dark);
    // final cupertinoLightTheme = MaterialBasedCupertinoThemeData(materialTheme: ThemeData.Light);
    // final cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
    //   materialTheme: materialDarkTheme.copyWith(
    //     cupertinoOverrideTheme: CupertinoThemeData(
    //       brightness: Brightness.dark,
    //       barBackgroundColor:
    //       darkDefaultCupertinoTheme.barBackgroundColor,
    //       textTheme: CupertinoTextThemeData(
    //         navActionTextStyle: darkDefaultCupertinoTheme
    //             .textTheme.navActionTextStyle
    //             .copyWith(color: darkTheme.primaryColor),
    //         navLargeTitleTextStyle: darkDefaultCupertinoTheme
    //             .textTheme.navLargeTitleTextStyle
    //             .copyWith(color: const Color(0xF0F9F9F9)),
    //       ),
    //     ),
    //   ),
    // );

    return PlatformProvider(
      builder: (context) => DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
              PlatformTheme(
                themeMode: ThemeMode.system,
                materialDarkTheme: ThemeData(
                    colorScheme: darkDynamic,
                    textTheme: interTextTheme,
                    fontFamily: "Inter"),
                materialLightTheme: ThemeData(
                    colorScheme: lightDynamic,
                    textTheme: interTextTheme,
                    fontFamily: "Inter"),
                cupertinoLightTheme: lightDefaultCupertinoTheme,
                cupertinoDarkTheme: darkDefaultCupertinoTheme,
                builder: (context) => const PlatformApp(
                  title: 'Flutter Platform Widgets',
                  home: HomeScreen(),
                  // Hide "Debug" banner
                  debugShowCheckedModeBanner: false,
                  // Platform App
                  localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                    DefaultMaterialLocalizations.delegate,
                    DefaultWidgetsLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate,
                  ],
                  // Preview
                  // locale: DevicePreview.locale(context),
                  // builder: DevicePreview.appBuilder,
                ),
              )),
    );
  }
}
