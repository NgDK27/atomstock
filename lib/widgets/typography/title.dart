import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class OpTitle extends StatelessWidget {
  final Widget? leading;
  final String title;

  const OpTitle(
    this.title, {
    super.key,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: OpSpacing.xs2),
                  ],
                  Text(
                    title,
                    style: OpTextStyle.titleSmall(context)?.copyWith(
                      fontVariations: [const FontVariation.weight(600)],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: OpSpacing.xs),
        ],
      ),
    );
  }
}
