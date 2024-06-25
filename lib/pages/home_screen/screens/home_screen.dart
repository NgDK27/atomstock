import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/neutral/OpFilledNeutralButton.dart';
import 'package:oppenhomies/widgets/buttons/neutral/OpTonalNeutralButton.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledPrimaryButton.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/buttons/OpTextButton.dart';
import 'package:oppenhomies/widgets/scaffold/OpPlatformSliverScaffold.dart';

import '../../../widgets/buttons/primary/OpTonalPrimaryButton.dart';

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
                OpFilledGlowPrimaryButton(
                  text: "Filled Glow Button",
                  onPressed: () {},
                ),
                const SizedBox(height: OpSpacing.md),
                OpFilledPrimaryButton(
                  text: "Filled Button",
                  onPressed: () {},
                ),
                const SizedBox(height: OpSpacing.md),
                OpTonalPrimaryButton(
                  text: "Tonal Button",
                  onPressed: () {},
                ),
                const SizedBox(height: OpSpacing.md),
                OpTextButton(
                  text: "Text Button",
                  onPressed: () {},
                ),
                const SizedBox(height: OpSpacing.md),
                OpFilledNeutralButton(
                  text: "Filled Neutral Button",
                  onPressed: () {},
                ),
                const SizedBox(height: OpSpacing.md),
                OpTonalNeutralButton(
                  text: "Tonal Neutral Button",
                  onPressed: () {},
                ),
                const SizedBox(height: OpSpacing.md),
              ],
            ),
            childCount:5 ,
          ),
        ),
      );
}
