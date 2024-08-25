import 'package:flutter/material.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/illustrations/light_bulb_illustration.dart';

class ChatWelcomeScreen extends StatelessWidget {
  const ChatWelcomeScreen({super.key});

  static const List<String> promptHints = [
    "What's the market performance of...",
    "Tell me about the earnings of...",
    "How's the stock trending for...",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.5,
            child: LightBulbIllustration(
              overlayBeginColor: OpDynamicColor.primary(context),
              overlayEndColor: OpDynamicColor.primaryVariant(context),
              underlyingBeginColor: OpDynamicColor.primary(context),
              underlyingEndColor: OpDynamicColor.primaryVariant(context),
            ),
          ),
          Text(
            "Ask your AI Advisor about",
            style: OpTextStyle.titleMedium(context).bold(),
          ),
          const SizedBox(height: OpSpacing.xs),
          for (final hint in promptHints)
            Text(
              "\"$hint\"",
              style: OpTextStyle.labelLarge(context),
            ),
          const SizedBox(height: OpSpacing.sm),
        ],
      ),
    );
  }
}