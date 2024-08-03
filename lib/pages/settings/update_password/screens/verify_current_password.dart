import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/neutral/op_neutral_text_button.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/textfields/platform_animated_text_form_field.dart';

class VerifyCurrentPassword extends HookConsumerWidget {
  const VerifyCurrentPassword({super.key});

  void navigateForgotPassword(BuildContext context) {
    context.goNamed(OpRoutes.resetPassword.name);
  }

  void handleVerifyCurrentPassword(BuildContext context, String password) {
    // Show a dialog with the entered values
    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Verify Current Password Attempted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password: $password'),
          ],
        ),
        actions: [
          PlatformDialogAction(
            onPressed: () => context.goNamed(OpRoutes.inputNewPassword.name),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    // Optional: Log to console
    if (kDebugMode) {
      print('Sign in attempted - Password: $password');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = useTextEditingController();

    final password = useValueListenable(passwordController);

    final showPassword = useState(false);

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);

    const int validationDelay = 2;

    final passwordValidationMode = useState(AutovalidateMode.disabled);
    final passwordDebounced =
    useDebounced(password.text, const Duration(seconds: validationDelay));

    useEffect(() {
      if (passwordDebounced?.isNotEmpty == true) {
        passwordValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [passwordDebounced],);

    useEffect(() {
      if (password.text.isNotEmpty) {
        final isValid = formKey.currentState?.validate() ?? false;
        isFormValid.value = isValid;
      } else {
        isFormValid.value = false;
      }
      return null;
    }, [password],);

    return OpPlatformSliverScaffold(
      scrollable: true,
      title: "Verify current password",
      slivers: [
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: OpSpacing.lg),
                Form(
                  key: formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        PlatformTextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode:
                          passwordValidationMode.value,
                          enabled: true,
                          obscureText: showPassword.value ? false : true,
                          autofocus: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          validator:
                          AuthenticationValidator.passwordValidator,
                          hintText: AutofillHints.password.sentenceCase(),
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                        ).animated(),
                      ],
                    ),
                  ),),
                const SizedBox(height: OpSpacing.md),
                Row(
                  children: [
                    const Text("Show password"),
                    const Spacer(),
                    PlatformSwitch(
                      value: showPassword.value,
                      onChanged: (bool value) =>
                      showPassword.value = value,
                    ),
                  ],
                ),
              ],
            ),
          ),),
      ],
      floatingBottomWidget: BottomBar(
        child: OpFilledPrimaryButton(
          text: "Verify",
          onPressed: isFormValid.value
              ? () => handleVerifyCurrentPassword(
            context,  passwordController.text,)
              : null,),),);
  }
}
