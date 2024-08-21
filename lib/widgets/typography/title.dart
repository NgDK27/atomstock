import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class OpTitle extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? trailingText;
  final VoidCallback? trailingOnPressed;

  const OpTitle(
    this.title, {
    super.key,
    this.leading,
    this.trailingText,
    this.trailingOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: trailingText != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
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
              if (trailingText != null)
                RichText(
                  text: TextSpan(
                    text: trailingText,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => trailingOnPressed,
                    style: OpTextStyle.titleSmall(context).bold().copyWith(
                          color: OpDynamicColor.primary(context),
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: OpSpacing.xs),
        ],
      ),
    );
  }
}
