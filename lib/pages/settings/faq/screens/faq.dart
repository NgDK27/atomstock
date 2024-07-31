import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context) {
    return OpPlatformSliverScaffold(
      title: "FAQ",
      slivers: [
        SliverSafeArea(
          minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  "Example question",
                  style: OpTextStyle.titleLarge(context),
                ),
                const SizedBox(height: OpSpacing.xs),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod, nisi vel consectetur interdum, nisl nunc egestas nunc, vitae tincidunt nisl nunc eu nisi. Sed euismod, nisi vel consectetur interdum, nisl nunc egestas nunc, vitae tincidunt nisl nunc eu nisi.",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
