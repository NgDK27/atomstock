import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/neutral/op_neutral_text_button.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/textfields/platform_animated_text_form_field.dart';


class SignIn extends HookWidget {
  const SignIn({super.key});

  void navigateForgotPassword(BuildContext context) {
    context.goNamed(OpRoutes.resetPassword.name);
  }

  void handleSignIn(BuildContext context, String email, String password) {
    // Show a dialog with the entered values
    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Sign In Attempted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            const SizedBox(height: 8),
            Text('Password: $password'),
          ],
        ),
        actions: [
          PlatformDialogAction(
            onPressed: () => context.pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );

    // Optional: Log to console
    if (kDebugMode) {
      print('Sign in attempted - Email: $email, Password: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final email = useValueListenable(emailController);
    final password = useValueListenable(passwordController);
    
    final showPassword = useState(false);

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);

    const int validationDelay = 2;

    final emailValidationMode = useState(AutovalidateMode.disabled);
    final emailDebounced =
    useDebounced(email.text, const Duration(seconds: validationDelay));

    final passwordValidationMode = useState(AutovalidateMode.disabled);
    final passwordDebounced =
    useDebounced(password.text, const Duration(seconds: validationDelay));

    useEffect(() {
      if (emailDebounced?.isNotEmpty == true) {
        emailValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [emailDebounced],);

    useEffect(() {
      if (passwordDebounced?.isNotEmpty == true) {
        passwordValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [passwordDebounced],);

    useEffect(() {
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        final isValid = formKey.currentState?.validate() ?? false;
        isFormValid.value = isValid;
      } else {
        isFormValid.value = false;
      }
      return null;
    }, [email, password],);

    return OpPlatformSliverScaffold(
        scrollable: true,
        title: "Sign in",
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
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                    emailValidationMode.value,
                                enabled: true,
                                autofocus: true,
                                enableSuggestions: true,
                                autocorrect: false,
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                validator:
                                    AuthenticationValidator.emailValidator,
                                hintText: AutofillHints.email.sentenceCase(),
                                autofillHints: const [
                                  AutofillHints.email,
                                ],
                              ).animated(),
                              const SizedBox(height: OpSpacing.md),
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
                    const SizedBox(height: OpSpacing.lg),
                    OpNeutralTextButton(
                      leftAligned: true,
                      text: "Forgot your password?",
                      onPressed: () => navigateForgotPassword(context),
                    ),
                  ],
                ),
              ),),
        ],
        floatingBottomWidget: BottomBar(
            child: OpFilledPrimaryButton(
                text: "Sign in",
                onPressed: isFormValid.value
                    ? () => handleSignIn(
                        context, emailController.text, passwordController.text,)
                    : null,),),);
  }
}
