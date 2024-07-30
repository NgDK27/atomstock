import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class ConnectedAccounts extends StatelessWidget {
  const ConnectedAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return OpPlatformSliverScaffold(
      title: "Connected accounts",
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
                      color: OpDynamicColor.surfaceContainerHigh(context),
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
                                "Temporary Testing Info",
                                style: OpTextStyle.titleSmall(context).bold(),
                              ),
                            ],
                          ),
                          const SizedBox(height: OpSpacing.sm),
                          Text(
                            "During this testing phase, adding bank accounts or cards is not supported. Please use the provided free account to add and withdraw money.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: OpSpacing.md),
                ListTile(
                  title: Text("TymeX • Free Testing Account"),
                  trailing: Text("•••• 1234"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
