import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dynamic_color/dynamic_color.dart';

// Create a CounterNotifier class that extends StateNotifier
final counterProvider = StateProvider((ref) => 0);

void main() {
  runApp(
    const ProviderScope(
      child: OppenhomiesApp(),
    ),
  );
}

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class OppenhomiesApp extends ConsumerWidget {
  const OppenhomiesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const lightDefaultCupertinoTheme = CupertinoThemeData();
    // final cupertinoLightTheme = MaterialBasedCupertinoThemeData(materialTheme: ThemeData.Light);
    const darkDefaultCupertinoTheme =
        CupertinoThemeData(brightness: Brightness.dark);
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return PlatformProvider(
      builder: (context) => DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
              PlatformTheme(
                themeMode: ThemeMode.system,
                materialDarkTheme: ThemeData(
                  colorScheme: darkDynamic,
                ),
                materialLightTheme: ThemeData(colorScheme: lightDynamic),
                cupertinoLightTheme: lightDefaultCupertinoTheme,
                builder: (context) => const PlatformApp(
                  localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                    DefaultMaterialLocalizations.delegate,
                    DefaultWidgetsLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate,
                  ],
                  title: 'Flutter Platform Widgets',
                  home: HomePage(),
                  debugShowCheckedModeBanner: false, // Set this to false
                ),
              )),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int value = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(value.toString()),
      ),
      body: ListView.builder(
        itemCount: 20,
        addAutomaticKeepAlives: true,
        primary: false,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text((index + 1).toString()),
            ),
            title: Text('Item ${index + 1}'),
            subtitle: Text('This is item number ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Handle item tap action here
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}