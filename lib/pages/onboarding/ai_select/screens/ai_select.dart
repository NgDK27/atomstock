import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/pages/onboarding/ai_select/layouts/ai_select_card.dart';
import 'package:oppenhomies/pages/onboarding/ai_select/models/AiSelectCardData.dart';
import 'package:oppenhomies/pages/onboarding/ai_select/models/AiSelectCardModel.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/neutral/op_neutral_text_button.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/gradients/gradient.dart';
import 'package:oppenhomies/widgets/scaffolds/edge_to_edge_scaffold.dart';

class AiSelect extends ConsumerStatefulWidget {
  const AiSelect({super.key});

  @override
  ConsumerState createState() => _AiSelectState();
}

class _AiSelectState extends ConsumerState<AiSelect> {
  final allAis = AiSelectCardData.allAis;
  int _current = 0;

  void _navigateBack() {
    context.pop();
  }

  void _navigateSignUp() {
    context.goNamed(OpRoutes.signUpLanding.name);
  }

  @override
  Widget build(BuildContext context) {
    return OpPlatformEdgeToEdgeScaffold(
        leadingNavigation: _navigateBack,
        child: Container(
          decoration: BoxDecoration(
            gradient: OpGradient.pageGradient(context,
                beginColor: OpDynamicColor.aiHarmonized(context)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: OpSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
                  child: Text(
                    "Which AI Advisor matches your vibe?",
                    style: OpTextStyle.display(context),
                  ),
                ),
                const SizedBox(height: OpSpacing.xl2),
                Expanded(
                  child: CarouselSlider(
                    items: allAis
                        .map((model) => AiSelectCard(model: model))
                        .toList(),
                    options: CarouselOptions(
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                        aspectRatio: 0.5,
                        clipBehavior: Clip.none,
                        onPageChanged: (index, _) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                ),
                const SizedBox(height: OpSpacing.sm),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: allAis.asMap().entries.map((entry) {
                      return Container(
                        width: 4.0,
                        height: 4.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == entry.key
                                ? OpDynamicColor.onSurface(context)
                                : OpDynamicColor.onSurfaceVariant(context)
                                    .withOpacity(OpOpacity.tertiary)),
                      );
                    }).toList()),
                const SizedBox(height: OpSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
                  child: switch (allAis[_current].type) {
                    AiSelectCardType.recommended => OpFilledGlowPrimaryButton(
                        text: "Select ${allAis[_current].aiName}",
                        onPressed: _navigateSignUp,
                      ),
                    AiSelectCardType.comingSoon =>
                      const OpNeutralTextButton(text: "Coming soon"),
                  },
                )
              ],
            ),
          ),
        ));
  }
}
