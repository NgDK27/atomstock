import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';

import '../../../styles/colors.dart';
import '../../../widgets/gradients/gradient.dart';
import '../layouts/ai_select_card.dart';
import '../models/AiSelectCardData.dart';

class AiSelect extends ConsumerWidget {
  const AiSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidgetBuilder(
        material: (_, child, __) => Scaffold(
              appBar: AppBar(
                leading: PlatformIconButton(
                  icon: Icon(PlatformIcons(context).back),
                  onPressed: () {},
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              extendBodyBehindAppBar: true,
              body: child,
            ),
        cupertino: (_, child, __) => CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                border: Border(bottom: BorderSide(color: Colors.transparent)),
                padding: EdgeInsetsDirectional.zero,
                backgroundColor: Colors.transparent,
                leading: CupertinoNavigationBarBackButton(
                  onPressed: () {},
                  color: OpDynamicColor.onSurface(context),
                ),
              ),
              child: child!,
            ),
        child: Container(
          decoration: BoxDecoration(
            gradient: OpGradient.pageGradient(context,
                beginColor: OpDynamicColor.aiHarmonized(context)),
          ),
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: OpSpacing.sm),
                Text(
                  "Which AI Advisor matches your vibe?",
                  style: OpTextStyle.display(context),
                ),
                const SizedBox(height: OpSpacing.xl),
                Expanded(
                    child: Column(
                  children: [
                    AiSelectCard(
                      model: AiSelectCardData.rocketScienceAi(context),
                    ),
                  ],
                )),
                OpFilledGlowPrimaryButton(
                  text: "Select",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}

class SpecialColor extends Color {
  const SpecialColor() : super(0x00000000);

  @override
  int get alpha => 0xFF;
}