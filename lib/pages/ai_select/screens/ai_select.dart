import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/ai_select/models/AiSelectCardModel.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/buttons/OpTextButton.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';

import '../../../styles/colors.dart';
import '../../../widgets/gradients/gradient.dart';
import '../layouts/ai_select_card.dart';
import '../models/AiSelectCardData.dart';

class AiSelect extends ConsumerStatefulWidget {
  const AiSelect({super.key});

  @override
  ConsumerState createState() => _AiSelectState();
}

class _AiSelectState extends ConsumerState<AiSelect> {
  final allAis = AiSelectCardData.allAis;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
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
                  color: OpDynamicColor.onSurfaceVariant(context),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: OpSpacing.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: OpSpacing.md),
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
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == entry.key ? OpDynamicColor.onSurface(context) : OpDynamicColor.onSurfaceVariant(context).withOpacity(OpOpacity.tertiary)),
                      );
                    }).toList()),
                const SizedBox(height: OpSpacing.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: OpSpacing.md),
                  child: switch (allAis[_current].type) {
                    AiSelectCardType.recommended => OpFilledGlowPrimaryButton(
                        text: "Select ${allAis[_current].aiName}",
                        onPressed: () {},
                      ),
                    AiSelectCardType.comingSoon =>
                      OpTextButton(text: "Coming soon"),
                  },
                )
              ],
            ),
          ),
        ));
  }
}
