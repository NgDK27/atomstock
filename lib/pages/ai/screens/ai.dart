import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class Ai extends ConsumerWidget {
  const Ai({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      OpPlatformSliverScaffold(title: "AI",
          transitionBetweenRoutes: false,
          slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    SizedBox(height: OpSpacing.md),

                  ]
              ),
              childCount: 15,
            ),
          ),
        )
      ]);
}
