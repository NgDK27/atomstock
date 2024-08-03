import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class ThirdPartySignIn extends StatelessWidget {
  const ThirdPartySignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return OpPlatformSliverScaffold(
      title: "Third-party sign in",
      topBarTrailing: PlatformIconButton(
        icon: Icon(PlatformIcons(context).add),
      ),
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: OpSpacing.md),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(OpRadius.md)),
                      color: OpDynamicColor.surfaceContainer(context),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(OpSpacing.md),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                PlatformIcons(context).info,
                                applyTextScaling: true,
                                size: OpTextStyle.titleLarge(context)?.fontSize,
                              ),
                              const SizedBox(width: OpSpacing.xs),
                              Text(
                                "Third-party sign in not available yet",
                                style: OpTextStyle.titleSmall(context).bold(),
                              ),
                            ],
                          ),
                          const SizedBox(height: OpSpacing.sm),
                          Text(
                            "This feature will be supported in a future update. Please check back soon.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: OpSpacing.md),
                PlatformListTile(
                  title: Text("Email"),
                  trailing: Text("example@email.com"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
