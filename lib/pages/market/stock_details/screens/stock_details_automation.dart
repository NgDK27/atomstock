import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class StockDetailsAutomation extends StatelessWidget {
  const StockDetailsAutomation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: OpSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🚧',
              style: OpTextStyle.display(context)?.copyWith(fontSize: 80),
            ),
            const SizedBox(
              height: OpSpacing.sm,
            ),
            Text(
              "This feature is under construction",
              style: OpTextStyle.titleLarge(context),
            ),
            const SizedBox(
              height: OpSpacing.xs,
            ),
            Text(
              "You'll be able to manage automations with this stock once this feature is complete!",
              style: OpTextStyle.labelLarge(context)
                  ?.copyWith(color: OpDynamicColor.onSurfaceVariant(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
    );
  }
}
