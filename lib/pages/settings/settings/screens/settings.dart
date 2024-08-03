import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/pages/onboarding/ai_select/models/AiSelectCardData.dart';
import 'package:oppenhomies/pages/settings/settings/layouts/ai_select_card_settings.dart';
import 'package:oppenhomies/pages/settings/settings/model/SettingsDestination.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/neutral/OpFilledNeutralButton.dart';
import 'package:oppenhomies/widgets/divider/divider_variant.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<SettingsDestination> settingsItems = [
      SettingsDestination(
        title: "Add funds",
        route: OpRoutes.addFunds.name,
        materialIcon: Icons.add,
        cupertinoIcon: CupertinoIcons.add,
      ),
      SettingsDestination(
        title: "Withdraw funds",
        route: OpRoutes.withdrawFunds.name,
        materialIcon: Icons.account_balance_wallet,
        cupertinoIcon: CupertinoIcons.creditcard,
      ),
      SettingsDestination(
        title: "Connected accounts",
        route: OpRoutes.connectedAccounts.name,
        materialIcon: Icons.account_balance,
        cupertinoIcon: CupertinoIcons.person_crop_circle,
      ),
      SettingsDestination(
        title: "Your name",
        route: OpRoutes.yourName.name,
        materialIcon: Icons.text_format,
        cupertinoIcon: CupertinoIcons.textformat,
      ),
      SettingsDestination(
        title: "Update email",
        route: OpRoutes.verifyCurrentEmail.name,
        materialIcon: Icons.email,
        cupertinoIcon: CupertinoIcons.mail,
      ),
      SettingsDestination(
        title: "Update password",
        route: OpRoutes.updatePassword.name,
        materialIcon: Icons.lock,
        cupertinoIcon: CupertinoIcons.lock,
      ),
      SettingsDestination(
        title: "Third-party sign in",
        route: OpRoutes.thirdPartySignIn.name,
        materialIcon: Icons.account_circle_sharp,
        cupertinoIcon: CupertinoIcons.checkmark_shield,
      ),
      SettingsDestination(
        title: "Appearance",
        route: OpRoutes.appearance.name,
        materialIcon: Icons.palette,
        cupertinoIcon: CupertinoIcons.paintbrush,
      ),
      SettingsDestination(
        title: "Language",
        route: OpRoutes.language.name,
        materialIcon: Icons.translate,
        cupertinoIcon: CupertinoIcons.t_bubble,
      ),
      SettingsDestination(
        title: "FAQ",
        route: OpRoutes.faq.name,
        materialIcon: Icons.question_answer,
        cupertinoIcon: CupertinoIcons.chat_bubble_2,
      ),
      SettingsDestination(
        title: "Contact support",
        route: OpRoutes.contactSupport.name,
        materialIcon: Icons.help,
        cupertinoIcon: CupertinoIcons.question_circle,
      ),
    ];

    void handleSignOut() {
      showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          title: Text("Sign out attempted"),
          actions: [
            PlatformDialogAction(
              child: Text("OK"),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return OpPlatformSliverScaffold(
      title: "Settings",
      transitionBetweenRoutes: false,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  // Add AiSelectCardSettings as the first item
                  return Column(
                    children: [

                      AiSelectCardSettings(
                        model: AiSelectCardData.slowAndSteadyAi,
                      ),
                      SizedBox(height: OpSpacing.sm),
                    ],
                  );
                } else if (index <= settingsItems.length) {
                  final itemData = settingsItems[index - 1];
                  return Column(
                    children: [
                      PlatformListTile(
                        title: Text(itemData.title),
                        onTap: () => context.pushNamed(itemData.route),
                        leading: PlatformWidget(
                          material: (_, __) => Icon(itemData.materialIcon),
                          cupertino: (_, __) => Icon(itemData.cupertinoIcon),
                        ),
                        trailing: PlatformWidget(
                          material: (context, __) => Icon(
                            Icons.chevron_right,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(OpOpacity.secondary),
                          ),
                          cupertino: (context, __) => Icon(
                            CupertinoIcons.chevron_right,
                            size: 16,
                            color: OpDynamicColor.onSurfaceVariant(context),
                          ),
                        ),
                        cupertino: (_, __) => CupertinoListTileData(
                          padding: EdgeInsets.symmetric(vertical: OpSpacing.sm, horizontal: OpSpacing.md)
                        ),
                      ),
                      if (index == 3 || index == 7 || index == 9)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: OpSpacing.md),
                          child: OpDividerVariant(),
                        ),
                    ],
                  );
                } else if (index == settingsItems.length + 1) {
                  return Padding(
                    padding: EdgeInsets.all(OpSpacing.md),
                    child: OpFilledNeutralButton(
                      onPressed: handleSignOut,
                      text: 'Sign out',
                    ),
                  );
                }
                return null;
              },
              childCount: settingsItems.length +
                  2, // +1 for AiSelectCardSettings, +1 for the button
            ),
          ),
        ),
      ],
    );
  }
}
