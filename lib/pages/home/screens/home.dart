import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpTonalPrimaryButton.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  void navigateSettings(
    BuildContext context,
  ) {
    context.pushNamed(OpRoutes.settings.name);
  }

  void navigateNotifications(
    BuildContext context,
  ) {
    context.pushNamed(OpRoutes.notifications.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => OpPlatformSliverScaffold(
          title: "Home",
          topBarLeading: PlatformIconButton(
            cupertino: (_, __) =>
                CupertinoIconButtonData(padding: EdgeInsets.zero),
            icon: Icon(platformThemeData(context,
                material: (_) => Icons.account_circle,
                cupertino: (_) => CupertinoIcons.person_circle_fill,),),
            onPressed: () => navigateSettings(context),
          ),
          topBarTrailing: PlatformIconButton(
            cupertino: (_, __) =>
                CupertinoIconButtonData(padding: EdgeInsets.zero),
            icon: Icon(platformThemeData(context,
                material: (_) => Icons.notifications,
                cupertino: (_) => CupertinoIcons.bell_fill,),),
            onPressed: () => navigateNotifications(context),
          ),
          transitionBetweenRoutes: false,
          slivers: [
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OpTonalPrimaryButton(
                          text: "Filled Glow Button",
                          onPressed: () {},
                        ),
                        const SizedBox(height: OpSpacing.md),
                      ],),
                  childCount: 15,
                ),
              ),
            ),
          ],);
}
