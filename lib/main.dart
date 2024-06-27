import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/home_screen/screens/home_screen.dart';
import 'package:oppenhomies/pages/onboarding/screens/onboarding_ai.dart';
import 'package:oppenhomies/pages/onboarding/screens/onboarding_general.dart';
import 'package:oppenhomies/pages/onboarding/screens/onboarding_portfolio.dart';
import 'package:oppenhomies/pages/onboarding/screens/onboarding_security.dart';
import 'package:oppenhomies/pages/onboarding/screens/onboarding_trading.dart';
import 'package:oppenhomies/pages/onboarding/screens/onboarding_story.dart';
import 'package:oppenhomies/styles/cupertino_theme.dart';
import 'package:oppenhomies/styles/fonts.dart';

void main() {
  runApp(
    const ProviderScope(
      child: OppenhomiesApp(),
    ),
  );
}

class OppenhomiesApp extends ConsumerWidget {
  const OppenhomiesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Edge-to-edge
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return PlatformProvider(
      builder: (context) => DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
              PlatformTheme(
                themeMode: ThemeMode.system,
                materialDarkTheme: ThemeData(
                    colorScheme: darkDynamic, textTheme: opMaterialTextTheme),
                materialLightTheme: ThemeData(
                    colorScheme: lightDynamic, textTheme: opMaterialTextTheme),
                cupertinoLightTheme: opCupertinoLightTheme,
                cupertinoDarkTheme: opCupertinoDarkTheme,
                builder: (context) => const PlatformApp(
                  title: 'Flutter Platform Widgets',
                  home: OnboardingStory(),
                  // Hide "Debug" banner
                  debugShowCheckedModeBanner: false,
                  // Platform App
                  localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                    DefaultMaterialLocalizations.delegate,
                    DefaultWidgetsLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate,
                  ],
                ),
              )),
    );
  }
}
