import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/status/ui_state.dart';
import 'package:oppenhomies/domain/models/status/ui_states_enum.dart';
import 'package:oppenhomies/domain/providers/auth/sign_up_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpTonalPrimaryButton.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class SignUpVerify extends HookConsumerWidget {
  const SignUpVerify({super.key});

  void handleChangeEmail(
    BuildContext context,
  ) {
    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Change email address?'),
        content: const Text(
          "After changing the email address, you'll get another verification code",
        ),
        actions: [
          PlatformDialogAction(
            onPressed: () => context.pop(),
            child: Text('Cancel', style: OpTextStyle.bold()),
          ),
          PlatformDialogAction(
            onPressed: () => {context.pop(), context.pop()},
            child: Text('Change email', style: OpTextStyle.bold()),
          ),
        ],
      ),
    );
  }

  void handleResendEmail(
    BuildContext context,
  ) {
    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Another verification code has been sent'),
        content: const Text(
          "Make sure to check your 'spam' folder. If you still can't receive the email, please contact us for support",
        ),
        actions: [
          PlatformDialogAction(
            onPressed: () => context.pop(),
            child: Text('OK', style: OpTextStyle.bold()),
          ),
        ],
      ),
    );
  }

  Future<void> onCompleted(
      BuildContext context,
      WidgetRef ref,
      String code,
      TextEditingController textEditingController,
      ValueNotifier<UiState> uiState) async {
    uiState.value = UiState.loading();
    textEditingController.clear();

    final signUpNotifier = ref.read(signUpProvider.notifier);
    final result = await signUpNotifier.verifySignUp(otp: code);

    if (context.mounted) {
      uiState.value = result.uiState;
      switch (result.uiState.state) {
        case UiStates.success:
          context.goNamed(OpRoutes.home.name);
          break;
        case UiStates.failed:
          showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: const Text("Sign up verification unsuccessful"),
              content: Text(
                result.uiState.message ??
                    "Please check your code and try again.",
              ),
              actions: <Widget>[
                PlatformDialogAction(
                  child: const Text('OK'),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          );
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const codeLength = 6;
    final codeController = useTextEditingController();

    final signUpState = ref.watch(signUpProvider);
    final uiState = useState(UiState());

    return Stack(
      children: [
        OpPlatformSliverScaffold(
          title: "Check your inbox",
          slivers: [
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: OpSpacing.sm),
                    Text(
                      signUpState.tempEmail ?? "example@email.com",
                      style: OpTextStyle.titleLarge(context),
                    ),
                    const SizedBox(height: OpSpacing.md),
                    const Text(
                      "We’ve sent a verification code to your email. Enter it here and you’re done!",
                    ),
                    const SizedBox(height: OpSpacing.xl),
                    PlatformTextField(
                      // autofocus: true,
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      maxLength: codeLength,
                      hintText: '_' * codeLength,
                      textInputAction: TextInputAction.done,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      style: OpTextStyle.display(context)
                          ?.copyWith(letterSpacing: 5),
                      makeCupertinoDecorationNull: true,
                      onChanged: (value) => value.length == codeLength
                          ? onCompleted(
                              context,
                              ref,
                              value,
                              codeController,
                              uiState,
                            )
                          : {},
                      material: (_, __) => MaterialTextFieldData(
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(inherit: true, letterSpacing: 15),
                        ),
                      ),
                      cupertino: (_, __) => CupertinoTextFieldData(
                        placeholderStyle: TextStyle(
                          color: OpDynamicColor.onSurface(context)
                              .withOpacity(OpOpacity.secondary),
                          letterSpacing: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          floatingBottomWidget: BottomBar(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "No email?",
                        style: OpTextStyle.labelLarge(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: OpSpacing.xs),
                      OpTonalPrimaryButton(
                        text: "Resend",
                        onPressed: () => handleResendEmail(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: OpSpacing.md,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Wrong email?",
                        style: OpTextStyle.labelLarge(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: OpSpacing.xs),
                      OpTonalPrimaryButton(
                        text: "Change",
                        onPressed: () => handleChangeEmail(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (uiState.value == UiState.loading())
          Container(
            color: OpDynamicColor.surface(context)
                .withOpacity(OpOpacity.secondary),
            child: Center(
              child: SizedBox(
                  height: OpSpacing.lg,
                  width: OpSpacing.lg,
                  child: PlatformCircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
