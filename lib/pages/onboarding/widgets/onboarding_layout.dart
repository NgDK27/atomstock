import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class OnboardingLayout extends StatelessWidget {
  final String text;

  const OnboardingLayout({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/onboarding_bg.png'),
              fit: BoxFit.cover,
              scale: 1.2,
              opacity: 0.6),
        ),
      ),
      SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 24),
            Text(
              text,
              style: platformThemeData(
                context,
                material: (ThemeData data) => data.textTheme.displaySmall,
                cupertino: (CupertinoThemeData data) =>
                    data.textTheme.navLargeTitleTextStyle,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(child: Container()),
            PlatformElevatedButton(
              child: const Text(
                "Sign in",
              ),
              onPressed: () {},
              cupertino: (_, __) => CupertinoElevatedButtonData(
                  borderRadius: const BorderRadius.all(Radius.circular(99))),
            ),
            const SizedBox(height: 4),
            PlatformTextButton(
              child: const Text(
                "Get started",
              ),
              onPressed: () {},
            ),
          ],
        ),
      ))
    ]);
  }
}
