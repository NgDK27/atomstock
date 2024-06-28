import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/illustrations/glassmorphism_base.dart';

import '../../../styles/opacities.dart';
import '../../../widgets/illustrations/light_bulb_illustration.dart';

class AiSelectCard extends ConsumerWidget {
  final GlassmorphismIllustration illustration;
  final String aiName;
  final String summary;
  final String description;
  final bool isAvailable;
  final bool isRecommended;
  final int accuracyPercentage;
  final String supportingText;

  const AiSelectCard(
      {this.illustration = const LightBulbIllustration(),
      required this.aiName,
      required this.summary,
      required this.description,
      this.isAvailable = true,
      this.isRecommended = false,
      required this.accuracyPercentage,
      required this.supportingText,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
            // TODO Make this into a re-usable widget
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      OpDynamicColor.ai.withOpacity(OpOpacity.tertiary),
                      OpDynamicColor.aiGradientOut
                    ]),
                border: Border.all(
                    color: OpDynamicColor.onSurfaceVariantStrokes, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(OpRadius.md))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  OpSpacing.md, OpSpacing.md, OpSpacing.md, OpSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 80,
                          height: 80,
                          child: Padding(
                            padding: EdgeInsets.all(OpSpacing.xs),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: illustration,
                            ),
                          )),
                      Container(
                        // TODO Add chip widget
                        child: Text('Recommended'),
                      )
                    ],
                  ),
                  SizedBox(height: OpSpacing.lg),
                  Row(
                    children: [
                      PlatformWidget(
                        material: (_, __) => Icon(Icons.star_rate_rounded),
                        cupertino: (_, __) => Icon(CupertinoIcons.star_fill),
                      ),
                      SizedBox(width: OpSpacing.xs),
                      Text(aiName, style: OpTextStyle.headline(context))
                    ],
                  ),
                  SizedBox(height: OpSpacing.lg),
                  Text(
                    summary, // TODO Add style
                  ),
                  SizedBox(height: OpSpacing.md),
                  Text(description
                      // TODO Add content and style
                      ),
                  SizedBox(height: OpSpacing.lg),
                  Divider(),
                  SizedBox(height: OpSpacing.md),
                  Row(
                    children: [
                      Text('$accuracyPercentage%'
                          // TODO Add style
                          ),
                      Text(' average weekly accuracy' // TODO Add style
                          ),
                    ],
                  ),
                  SizedBox(height: OpSpacing.xs3),
                  Text(supportingText // TODO Add style
                      )
                ],
              ),
            ))
      ],
    );
  }
}
