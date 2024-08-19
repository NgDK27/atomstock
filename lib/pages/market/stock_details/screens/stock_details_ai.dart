import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class StockDetailsAi extends StatelessWidget {
  const StockDetailsAi({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: OpSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🚧',
            style: OpTextStyle.display(context)?.copyWith(fontSize: 80),
          ),
          SizedBox(
            height: OpSpacing.sm,
          ),
          Text(
            "This feature is under construction",
            style: OpTextStyle.titleLarge(context),
          ),
          SizedBox(
            height: OpSpacing.xs,
          ),
          Text(
            "You'll be able to ask your AI Advisor about this stock once this feature is complete!",
            style: OpTextStyle.labelLarge(context)
                ?.copyWith(color: OpDynamicColor.onSurfaceVariant(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
