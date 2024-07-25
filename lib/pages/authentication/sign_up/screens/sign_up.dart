import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/textfields/platform_animated_text_form_field.dart';


class SignUp extends HookWidget {
  const SignUp({super.key});

  void handleSignUp(
      BuildContext context, String email, String password, String name,) {
    // Optional: Log to console
    if (kDebugMode) {
      print(
          'Sign up attempted - Email: $email, Password: $password, Name: $name',);
    }

    context.goNamed(OpRoutes.signUpVerify.name);
  }

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameController = useTextEditingController();

    final email = useValueListenable(emailController);
    final password = useValueListenable(passwordController);
    final name = useValueListenable(nameController);

    final showPassword = useState(false);

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);

    const int validationDelay = 2;

    final emailValidationMode = useState(AutovalidateMode.disabled);
    final emailDebounced =
        useDebounced(email.text, const Duration(seconds: validationDelay));

    final nameValidationMode = useState(AutovalidateMode.disabled);
    final nameDebounced =
        useDebounced(name.text, const Duration(seconds: validationDelay));

    final passwordValidationMode = useState(AutovalidateMode.disabled);
    final passwordDebounced =
        useDebounced(password.text, const Duration(seconds: validationDelay));

    useEffect(() {
      if (nameDebounced?.isNotEmpty == true) {
        nameValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [nameDebounced],);

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
      if (email.text.isNotEmpty &&
          password.text.isNotEmpty &&
          name.text.isNotEmpty) {
        final isValid = formKey.currentState?.validate() ?? false;
        isFormValid.value = isValid;
      } else {
        isFormValid.value = false;
      }
      return null;
    }, [email, password, name],);

    return OpPlatformSliverScaffold(
        scrollable: true,
        title: "Sign up",
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
                                keyboardType: TextInputType.text,
                                autovalidateMode: nameValidationMode.value,
                                enabled: true,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                enableSuggestions: true,
                                controller: nameController,
                                textInputAction: TextInputAction.next,
                                validator:
                                    AuthenticationValidator.fullNameValidator,
                                hintText: AutofillHints.name.sentenceCase(),
                                autofillHints: const [
                                  AutofillHints.name,
                                ],
                              ).animated(),
                              const SizedBox(height: OpSpacing.md),
                              PlatformTextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode: emailValidationMode.value,
                                enabled: true,
                                autofocus: false,
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
                              const SizedBox(height: OpSpacing.xs),
                              Text(
                                "We'll send a verification code to this email address",
                                style:
                                    OpTextStyle.labelMedium(context)?.copyWith(
                                  color:
                                      OpDynamicColor.onSurfaceVariant(context),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: OpSpacing.md),
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
                                validator:
                                    AuthenticationValidator.passwordValidator,
                                hintText: AutofillHints.password.sentenceCase(),
                                autofillHints: const [
                                  AutofillHints.password,
                                ],
                              ).animated(),
                              const SizedBox(height: OpSpacing.md),
                              Row(
                                children: [
                                  const Text("Show password"),
                                  const Spacer(),
                                  PlatformSwitch(
                                      value: showPassword.value,
                                      onChanged: (bool value) =>
                                          showPassword.value = value,),
                                ],
                              ),
                            ],
                          ),
                        ),),
                  ],
                ),
              ),),
        ],
        floatingBottomWidget: BottomBar(
            child: OpFilledPrimaryButton(
          text: "Sign up",
              onPressed: isFormValid.value
              ? () => handleSignUp(context, emailController.text,
                  passwordController.text, nameController.text,)
              : null,
        ),),);
  }
}
