import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/helpers/use_post_frame_effect.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/domain/models/state/states.dart';
import 'package:oppenhomies/domain/providers/auth/auth_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/neutral/op_neutral_text_button.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/textfields/platform_animated_text_form_field.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});

  void _navigateForgotPassword(BuildContext context) {
    context.goNamed(OpRoutes.resetPassword.name);
  }

  void _handleSignIn(WidgetRef ref, String email, String password) {
    ref.read(authProvider.notifier).signIn(
          email: email,
          password: password,
        );
  }

  (
    TextEditingController,
    TextEditingController,
    ValueNotifier<bool>,
    GlobalKey<FormState>,
    ValueNotifier<bool>,
    ValueNotifier<AutovalidateMode>,
    ValueNotifier<AutovalidateMode>
  ) _useFormState() {
    final emailController =
        useTextEditingController(text: "quan@quanhoangdo.com");
    final passwordController = useTextEditingController(text: "Quan@12345");
    final showPassword = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);
    final emailValidationMode = useState(AutovalidateMode.disabled);
    final passwordValidationMode = useState(AutovalidateMode.disabled);

    _useValidation(
      emailController: emailController,
      passwordController: passwordController,
      emailValidationMode: emailValidationMode,
      passwordValidationMode: passwordValidationMode,
      isFormValid: isFormValid,
      formKey: formKey,
    );

    return (
      emailController,
      passwordController,
      showPassword,
      formKey,
      isFormValid,
      emailValidationMode,
      passwordValidationMode
    );
  }

  void _useValidation({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required ValueNotifier<AutovalidateMode> emailValidationMode,
    required ValueNotifier<AutovalidateMode> passwordValidationMode,
    required ValueNotifier<bool> isFormValid,
    required GlobalKey<FormState> formKey,
  }) {
    const int validationDelay = 2;

    final email = useValueListenable(emailController);
    final password = useValueListenable(passwordController);

    final emailDebounced =
        useDebounced(email.text, const Duration(seconds: validationDelay));
    final passwordDebounced =
        useDebounced(password.text, const Duration(seconds: validationDelay));

    useEffect(() {
      if (emailDebounced?.isNotEmpty == true) {
        emailValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [emailDebounced]);

    useEffect(() {
      if (passwordDebounced?.isNotEmpty == true) {
        passwordValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [passwordDebounced]);

    useEffect(() {
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        final isValid = formKey.currentState?.validate() ?? false;
        isFormValid.value = isValid;
      } else {
        isFormValid.value = false;
      }
      return null;
    }, [email, password]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (
      emailController,
      passwordController,
      showPassword,
      formKey,
      isFormValid,
      emailValidationMode,
      passwordValidationMode
    ) = _useFormState();

    final auth = ref.watch(authProvider);

    usePostFrameEffect(() {
      switch (auth.state) {
        case States.success:
          context.goNamed(OpRoutes.home.name);
        case States.failed:
          showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: Text("Sign in unsuccessful"),
              content: Text(auth.message ?? "LOL"),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        case States.loading:
        case States.initialized:
        case States.awaitingUpdate:
          break;
      }
    }, [auth.state],);

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
                Text(ref.read(authProvider).state.toString()),
                const SizedBox(height: OpSpacing.lg),
                Form(
                  key: formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        PlatformTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: emailValidationMode.value,
                          enabled: true,
                          autofocus: true,
                          enableSuggestions: true,
                          autocorrect: false,
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          validator: AuthenticationValidator.emailValidator,
                          hintText: AutofillHints.email.sentenceCase(),
                          autofillHints: const [AutofillHints.email],
                        ).animated(),
                        const SizedBox(height: OpSpacing.md),
                        PlatformTextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: passwordValidationMode.value,
                          enabled: true,
                          obscureText: !showPassword.value,
                          autofocus: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          validator: AuthenticationValidator.passwordValidator,
                          hintText: AutofillHints.password.sentenceCase(),
                          autofillHints: const [AutofillHints.password],
                        ).animated(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: OpSpacing.md),
                Row(
                  children: [
                    const Text("Show password"),
                    const Spacer(),
                    PlatformSwitch(
                      value: showPassword.value,
                      onChanged: (bool value) => showPassword.value = value,
                    ),
                  ],
                ),
                const SizedBox(height: OpSpacing.lg),
                OpNeutralTextButton(
                  leftAligned: true,
                  text: "Forgot your password?",
                  onPressed: () => _navigateForgotPassword(context),
                ),
              ],
            ),
          ),
        ),
      ],
      floatingBottomWidget: BottomBar(
        child: OpFilledPrimaryButton(
          text: "Sign in",
          onPressed: isFormValid.value && auth.state != States.loading
              ? () => _handleSignIn(
                    ref,
                    emailController.text,
                    passwordController.text,
                  )
              : null,
          child: auth.state == States.loading
              ? SizedBox(
                  height: OpSpacing.md,
                  width: OpSpacing.md,
                  child: PlatformCircularProgressIndicator(),
                )
              : null,
        ),
      ),
    );
  }
}
