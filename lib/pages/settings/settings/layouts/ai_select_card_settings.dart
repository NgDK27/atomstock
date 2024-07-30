import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/onboarding/ai_select/models/AiSelectCardModel.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/chip/chip_base.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/icons/sparkle_filled.dart';

import '/widgets/divider/divider_variant.dart';

class AiSelectCardSettings extends ConsumerWidget {
  final AiSelectCardModel model;

  const AiSelectCardSettings({required this.model, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color themeColorHarmonized = model.themeColor.harmonized(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
        decoration: BoxDecoration(
            color: OpDynamicColor.surface(context).withOpacity(OpOpacity.secondary),
            borderRadius: const BorderRadius.all(Radius.circular(OpRadius.md)),),
        child: Container(
            decoration: BoxDecoration(
                gradient: OpGradient.pageGradient(context, beginColor: themeColorHarmonized),
                border: Border.all(
                    color: OpDynamicColor.outlineVariant(context), width: 1,),
                borderRadius: const BorderRadius.all(Radius.circular(OpRadius.md)),),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  OpSpacing.md, OpSpacing.md, OpSpacing.md, OpSpacing.lg,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 80,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(OpSpacing.xs),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: model.illustration,
                            ),
                          ),),
                          const ChipMediumPrimary(text: "Your AI Advisor"),
                    ],
                  ),
                  const SizedBox(height: OpSpacing.lg),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: const SparkleFilled(),
                      ),
                      const SizedBox(width: OpSpacing.xs2),
                      Text(model.aiName, style: OpTextStyle.bodyLarge(context).bold()),
                    ],
                  ),
                  const SizedBox(height: OpSpacing.xs),
                  Text(
                      model.summary,
                  ),
                ],
              ),
            ),),);
  }
}
