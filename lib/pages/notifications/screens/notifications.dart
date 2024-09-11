import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class Notifications extends ConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      OpPlatformSliverScaffold(
        title: "Notifications",
        transitionBetweenRoutes: false,
        slivers: [
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: OpSpacing.md,
                      vertical: OpSpacing.xl2,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Symbols.notifications_none_rounded,
                          color: OpDynamicColor.onSurface(context)
                              .withOpacity(OpOpacity.secondary),
                          size: 48,
                          weight: 600,
                        ),
                        SizedBox(
                          height: OpSpacing.xs,
                        ),
                        Text(
                          "No notifications",
                          style: OpTextStyle.body(context)?.copyWith(
                            color: OpDynamicColor.onSurface(context)
                                .withOpacity(OpOpacity.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              ),
            ),
          ),
        ],
      );
}
