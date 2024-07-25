import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/widgets/buttons/neutral/tonal_neutral_button.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/scaffolds/edge_to_edge_scaffold.dart';

import '../../../../styles/colors.dart';
import '../../../../styles/spacings.dart';
import '../../../../styles/text.dart';
import '../../../../widgets/divider/divider_variant.dart';
import '../../../../widgets/gradients/gradient.dart';

class AuthenticationLandingLayout extends ConsumerWidget {
  final String title;
  final bool showSupportingText;
  final String? supportingStartText;
  final String? supportingEndText;
  final String switchAuthenticationFlowText;
  final String switchAuthenticationFlowButtonText;
  final VoidCallback? navigateAuthenticateWithEmail;
  final VoidCallback? navigateSwitchAuthenticationFlow;
  final bool showSignInAlertDialog;

  const AuthenticationLandingLayout({
    super.key,
    required this.title,
    this.showSupportingText = false,
    this.supportingStartText = '',
    this.supportingEndText = '',
    required this.navigateAuthenticateWithEmail,
    required this.switchAuthenticationFlowText,
    required this.switchAuthenticationFlowButtonText,
    required this.navigateSwitchAuthenticationFlow,
    this.showSignInAlertDialog = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpPlatformEdgeToEdgeScaffold(
        // leadingNavigation: navigateBack,
        child: Container(
          decoration: BoxDecoration(
            gradient: OpGradient.pageGradient(context,
                beginColor: OpDynamicColor.aquaHarmonized(context),),
          ),
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: OpTextStyle.display(context),
                ),
                const SizedBox(height: OpSpacing.xs),
                if (showSupportingText)
                  RichText(
                      text: TextSpan(
                          style: OpTextStyle.body(context),
                          children: <TextSpan>[
                        TextSpan(text: supportingStartText),
                        TextSpan(
                            text: supportingEndText,
                            style: OpTextStyle.titleSmall(context)?.copyWith(
                                color: OpDynamicColor.aiHarmonized(context),),),
                      ],),),
                const SizedBox(height: OpSpacing.xl),
                OpFilledPrimaryButton(
                  text: "Continue with email",
                  onPressed: navigateAuthenticateWithEmail,
                ),
                // const SizedBox(height: OpSpacing.lg),
                // Text(
                //   "We're working on more ways to let you authenticate!\nCheck back later",
                //   style: OpTextStyle.labelMedium(context),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: OpSpacing.lg),
                const OpDividerVariant(),
                const SizedBox(height: OpSpacing.lg),
                Text(switchAuthenticationFlowText),
                const SizedBox(height: OpSpacing.md),
                OpTonalNeutralButton(
                    text: switchAuthenticationFlowButtonText,
                    onPressed: showSignInAlertDialog
                        ? () {
                            showPlatformDialog(
                                context: context,
                                builder: (_) => PlatformAlertDialog(
                                      title: const Text('Signing in will clear your current AI Advisor choice'),
                                      content: const Text('You will be using the chosen AI Advisor of the signed in account'),
                                      actions: <Widget>[
                                        PlatformDialogAction(
                                          child: const Text('Continue signing up'),
                                          onPressed: () => context.pop(),
                                          cupertino:(_, __) => CupertinoDialogActionData(
                                            isDefaultAction: true,
                                          ),
                                        ),
                                        PlatformDialogAction(
                                          onPressed:  navigateSwitchAuthenticationFlow,
                                          child: const Text('Clear choice and sign in'),
                                        ),
                                      ],
                                    ),);
                          }
                        : navigateSwitchAuthenticationFlow,),
              ],
            ),
          ),
        ),);
  }
}
