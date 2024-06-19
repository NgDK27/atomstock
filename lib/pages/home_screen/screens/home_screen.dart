import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/FilledGlowButton.dart';
import 'package:oppenhomies/widgets/scaffold/OpPlatformSliverScaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => OpPlatformSliverScaffold(
    title: "Test",
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OpFilledGlowButton(
                  text: "Button Text",
                  onPressed: () {},
                ),
                const SizedBox(height: OpSpacing.md),
              ],
            ),
            childCount: 1,
          ),
        ),
      );
}
