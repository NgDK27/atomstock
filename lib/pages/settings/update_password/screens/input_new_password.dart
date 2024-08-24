import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/textfields/platform_animated_text_form_field.dart';

class InputNewPassword extends HookConsumerWidget {
  const InputNewPassword({super.key});

  void handleInputNewPassword(
    BuildContext context,
    String password,
  ) {
    // Optional: Log to console
    if (kDebugMode) {
      print('Input new password attempted - Password: $password');
    }

    context.goNamed(OpRoutes.updatePasswordCompleted.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final password = useValueListenable(passwordController);
    final confirmPassword = useValueListenable(confirmPasswordController);

    final showPassword = useState(false);

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);

    const int validationDelay = 2;

    final passwordValidationMode = useState(AutovalidateMode.disabled);
    final passwordDebounced =
        useDebounced(password.text, const Duration(seconds: validationDelay));

    final confirmPasswordValidationMode = useState(AutovalidateMode.disabled);
    final confirmPasswordDebounced = useDebounced(
        confirmPassword.text, const Duration(seconds: validationDelay),);

    useEffect(
      () {
        if (passwordDebounced?.isNotEmpty == true) {
          passwordValidationMode.value = AutovalidateMode.always;
        }
        return null;
      },
      [passwordDebounced],
    );

    useEffect(
      () {
        if (confirmPasswordDebounced?.isNotEmpty == true) {
          passwordValidationMode.value = AutovalidateMode.always;
        }
        return null;
      },
      [confirmPasswordDebounced],
    );

    useEffect(
      () {
        if (password.text.isNotEmpty && confirmPassword.text.isNotEmpty) {
          final isValid = formKey.currentState?.validate() ?? false;
          isFormValid.value = isValid;
        } else {
          isFormValid.value = false;
        }
        return null;
      },
      [password, confirmPassword],
    );

    return OpPlatformSliverScaffold(
      scrollable: true,
      title: "Input new password",
      slivers: [
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: OpSpacing.lg),
                Form(
                  key: formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PlatformTextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: passwordValidationMode.value,
                          enabled: true,
                          obscureText: showPassword.value ? false : true,
                          autofocus: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          // TODO: Show error in case new password = old password
                          // Might need to check the hash with server
                          validator: AuthenticationValidator.passwordValidator,
                          hintText: "New password",
                          autofillHints: const [
                            AutofillHints.newPassword,
                          ],
                        ).animated(),
                        const SizedBox(height: OpSpacing.md),
                        PlatformTextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: confirmPasswordValidationMode.value,
                          enabled: true,
                          obscureText: showPassword.value ? false : true,
                          autofocus: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: confirmPasswordController,
                          textInputAction: TextInputAction.done,
                          validator: (value) => AuthenticationValidator.confirmPasswordValidator(value, password.text),
                          hintText: "Confirm new password",
                          autofillHints: const [
                            AutofillHints.newPassword,
                          ],
                        ).animated(),
                        const SizedBox(height: OpSpacing.md),
                        Row(
                          children: [
                            const Text("Show passwords"),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      floatingBottomWidget: BottomBar(
        child: OpFilledPrimaryButton(
          text: "Save",
          onPressed: isFormValid.value
              ? () => handleInputNewPassword(
                    context,
                    passwordController.text,
                  )
              : null,
        ),
      ),
    );
  }
}
