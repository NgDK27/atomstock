import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/onboarding/screens/onboarding_stories.dart';
import 'package:story/story_page_view.dart';

import '../../../styles/spacings.dart';
import '../../../widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import '../../../widgets/buttons/primary/OpTonalPrimaryButton.dart';

class OnboardingStory extends ConsumerStatefulWidget {
  const OnboardingStory({super.key});

  @override
  ConsumerState createState() => _OnboardingStoryState();
}

class _OnboardingStoryState extends ConsumerState<OnboardingStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          return onboardingStories.stories[storyIndex];
        },
        gestureItemBuilder: (_, __, ___) {
          return SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  OpTonalPrimaryButton(
                    text: "Sign in",
                    onPressed: () {},
                  ),
                  const SizedBox(height: OpSpacing.sm),
                  OpFilledGlowPrimaryButton(
                    text: "Get started",
                    onPressed: () {},
                  ),
                ],
              ));
        },
        indicatorPadding: EdgeInsets.fromLTRB(
            OpSpacing.md, MediaQuery.of(context).padding.top, OpSpacing.md, 0),
        pageLength: 1,
        storyLength: (_) {
          return 6;
        },
        onPageLimitReached: () {},
      ),
    );
  }
}
