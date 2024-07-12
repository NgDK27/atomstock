import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/pages/onboarding/story/screens/onboarding_stories.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpTonalPrimaryButton.dart';
import 'package:story/story_page_view.dart';

class OnboardingStory extends ConsumerStatefulWidget {
  const OnboardingStory({super.key});

  @override
  ConsumerState createState() => _OnboardingStoryState();
}

class _OnboardingStoryState extends ConsumerState<OnboardingStory> {
  void _navigateSignIn() {
    context.goNamed(OpRoutes.signInLanding.name);
  }

  void _navigateSignUp() {
    context.goNamed(OpRoutes.aiSelect.name);
  }

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
                    onPressed: _navigateSignIn,
                  ),
                  const SizedBox(height: OpSpacing.sm),
                  OpFilledGlowPrimaryButton(
                    text: "Get started",
                    onPressed: _navigateSignUp,
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
