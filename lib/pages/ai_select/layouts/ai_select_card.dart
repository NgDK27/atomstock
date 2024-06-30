import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/chip/chip_base.dart';
import 'package:oppenhomies/widgets/icons/sparkle.dart';

import '../models/AiSelectCardModel.dart';

class AiSelectCard extends ConsumerWidget {
  final AiSelectCardModel model;

  const AiSelectCard({required this.model, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
            color: OpDynamicColor.surface(context).withOpacity(OpOpacity.secondary),
            borderRadius: BorderRadius.all(Radius.circular(OpRadius.md))),
        child: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1,
                  colors: [
                    model.themeColor.withOpacity(OpOpacity.quaternary),
                    model.themeColor.withOpacity(OpOpacity.quaternary * 2 / 3),
                    model.themeColor.withOpacity(OpOpacity.quaternary * 1 / 3),
                    model.themeColor.withOpacity(OpOpacity.quaternary * 1 / 6),
                    model.themeColor.withOpacity(OpOpacity.quaternary * 1 / 15),
                    OpDynamicColor.surface(context).withOpacity(0.0),
                  ],
                  stops: [0.0, 0.3, 0.5, 0.7, 0.9, 1.0],
                ),
                border: Border.all(
                    color: OpDynamicColor.outlineVariant(context), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(OpRadius.md))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  OpSpacing.md, OpSpacing.md, OpSpacing.md, OpSpacing.lg),
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
                          )),
                      switch (model.type) {
                        AiSelectCardType.recommended =>
                          ChipMediumPrimary(text: "Recommended"),
                        AiSelectCardType.comingSoon =>
                          ChipMediumNeutral(text: "Coming soon"),
                      }
                    ],
                  ),
                  SizedBox(height: OpSpacing.lg),
                  Row(
                    children: [
                      Sparkle(),
                      SizedBox(width: OpSpacing.xs),
                      Text(model.aiName, style: OpTextStyle.headline(context))
                    ],
                  ),
                  SizedBox(height: OpSpacing.lg),
                  Text(
                    model.summary, // TODO Add style
                  ),
                  SizedBox(height: OpSpacing.md),
                  MarkdownBody(
                    data: model.description,
                    styleSheet: MarkdownStyleSheet(
                        p: OpTextStyle.labelLarge(context),
                        listBullet: OpTextStyle.labelLarge(context)),
                  ),
                  SizedBox(height: OpSpacing.lg),
                  Divider(
                    color: OpDynamicColor.outlineVariant(context),
                  ),
                  SizedBox(height: OpSpacing.md),
                  Row(
                    children: [
                      Text('${model.accuracyPercentage}%',
                          style: OpTextStyle.labelMediumProminent(context)
                              ?.copyWith(color: model.themeColor)),
                      Text(
                        ' average weekly accuracy',
                        style: OpTextStyle.labelMediumProminent(context)
                            ?.copyWith(
                                color: OpDynamicColor.onSurface(context)),
                      ),
                    ],
                  ),
                  SizedBox(height: OpSpacing.xs3),
                  Text(model.supportingText,
                      style: OpTextStyle.labelMedium(context)?.copyWith(
                          color: OpDynamicColor.onSurfaceVariant(context)))
                ],
              ),
            )));
  }
}
