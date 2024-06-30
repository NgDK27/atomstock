import 'package:flutter/cupertino.dart';

import '../../../styles/colors.dart';
import '../../../widgets/illustrations/light_bulb_illustration.dart';
import 'AiSelectCardModel.dart';

class AiSelectCardData {
  static AiSelectCardModel slowAndSteadyAi(BuildContext context) =>
      AiSelectCardModel(
        themeColor: OpDynamicColor.aiHarmonized(context),
        aiName: "Slow and Steady",
        type: AiSelectCardType.recommended,
        summary:
            'Tuned for the right mix of risk and reward, personalized to your choices',
        description: '''
- Balanced portfolio for low risk tolerance
- Consistent, long term growth approach
- Regular balancing for optimal allocation
- Diversified across sectors and assets
''',
        illustration: LightBulbIllustration(
          overlayBeginColor: OpDynamicColor.aiHarmonized(context),
          overlayEndColor: OpDynamicColor.aiHarmonized(context),
          underlyingBeginColor: OpDynamicColor.aiHarmonized(context),
          underlyingEndColor: OpDynamicColor.aiHarmonized(context),
        ),
        accuracyPercentage: 78,
        supportingText: 'Over the past 6 months',
      );

  static AiSelectCardModel playItSaferAi(BuildContext context) =>
      AiSelectCardModel(
        themeColor: OpDynamicColor.aquaHarmonized(context),
        aiName: "Play it Safer",
        type: AiSelectCardType.comingSoon,
        summary:
        'Prioritizing capital preservation and stability, for safe, long-term investment',
        description: '''
- Low-risk portfolio with minimal volatility
- Focus on safe, reliable investments
- Emphasis on bonds and blue-chip stocks
- Gradual, steady growth over time
''',
        illustration: LightBulbIllustration(
          overlayBeginColor: OpDynamicColor.aquaHarmonized(context),
          overlayEndColor: OpDynamicColor.aquaHarmonized(context),
          underlyingBeginColor: OpDynamicColor.aquaHarmonized(context),
          underlyingEndColor: OpDynamicColor.aquaHarmonized(context),
        ),
        accuracyPercentage: 80,
        supportingText: 'During testing',
      );

  static AiSelectCardModel rocketScienceAi(BuildContext context) =>
      AiSelectCardModel(
        themeColor: OpDynamicColor.cherryHarmonized(context),
        aiName: "Rocket Science",
        type: AiSelectCardType.comingSoon,
        summary:
        'Aggressive strategies aimed at maximizing returns, for risk-takers',
        description: '''
- High-growth portfolio with high potential
- Focus on emerging markets investments
- Leveraged positions to amplify returns
- Frequent balancing to catch trends
''',
        illustration: LightBulbIllustration(
          overlayBeginColor: OpDynamicColor.cherryHarmonized(context),
          overlayEndColor: OpDynamicColor.cherryHarmonized(context),
          underlyingBeginColor: OpDynamicColor.cherryHarmonized(context),
          underlyingEndColor: OpDynamicColor.cherryHarmonized(context),
        ),
        accuracyPercentage: 82,
        supportingText: 'During testing',
      );
}
