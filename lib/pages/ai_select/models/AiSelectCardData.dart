import 'package:oppenhomies/widgets/illustrations/piggy_bank_illustration.dart';
import 'package:oppenhomies/widgets/illustrations/rocket_illustration.dart';

import '../../../styles/colors.dart';
import '../../../widgets/illustrations/light_bulb_illustration.dart';
import 'AiSelectCardModel.dart';

class AiSelectCardData {
  static AiSelectCardModel get slowAndSteadyAi =>
      AiSelectCardModel(
        themeColor: OpLightDarkColor.ai,
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
          overlayBeginColor: OpLightDarkColor.ai,
          overlayEndColor: OpLightDarkColor.ai,
          underlyingBeginColor: OpLightDarkColor.ai,
          underlyingEndColor: OpLightDarkColor.ai,
        ),
        accuracyPercentage: 78,
        supportingText: 'Over the past 6 months',
      );

  static AiSelectCardModel get playItSaferAi =>
      AiSelectCardModel(
        themeColor: OpLightDarkColor.primary,
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
        illustration: PiggyBankIllustration(
          overlayBeginColor: OpLightDarkColor.primary,
          overlayEndColor: OpLightDarkColor.primary,
          underlyingBeginColor: OpLightDarkColor.primary,
          underlyingEndColor: OpLightDarkColor.primary,
        ),
        accuracyPercentage: 80,
        supportingText: 'During testing',
      );

  static AiSelectCardModel get rocketScienceAi =>
      AiSelectCardModel(
        themeColor: OpLightDarkColor.stockFall,
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
        illustration: RocketIllustration(
          overlayBeginColor: OpLightDarkColor.stockFall,
          overlayEndColor: OpLightDarkColor.stockFall,
          underlyingBeginColor: OpLightDarkColor.stockFall,
          underlyingEndColor: OpLightDarkColor.stockFall,

        ),
        accuracyPercentage: 82,
        supportingText: 'During testing',
      );

  static List<AiSelectCardModel> get allAis => [
        slowAndSteadyAi,
        playItSaferAi,
        rocketScienceAi,
      ];
}
