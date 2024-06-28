import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/ai_select/layouts/ai_select_card.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';

class AiSelect extends ConsumerWidget {
  const AiSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Column(
          children: [
            // TODO Add nav bar
            SafeArea(
                minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Which AI Advisor matches your vibe?",
                      style: OpTextStyle.display(context),
                    ),
                    AiSelectCard(
                      aiName: "Slow and Steady",
                      summary:
                          'Tuned for the right mix of risk and reward, personalized to your choices',
                      description: '''
                      Balanced portfolio for low risk tolerance
Consistent, long-term growth approach
Regular re-balancing for optimal allocation
Diversified across sectors and assets''', accuracyPercentage: 78, supportingText: 'Over the past 6 months',
                    ),
                    // TODO Add horizontal scroll indicator
                    OpFilledGlowPrimaryButton(
                      text: "Select", onPressed: () {},
                      // TODO Customize the text here
                    )
                  ],
                ))
          ],
        )
      ],
    );
  }
}
