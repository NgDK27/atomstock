import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/domain/models/status/ui_state.dart';
import 'package:oppenhomies/domain/models/status/ui_states_enum.dart';
import 'package:oppenhomies/domain/providers/auth/sign_in_provider.dart';
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

  Future<void> _handleSignIn(BuildContext context, WidgetRef ref, String email,
      String password, ValueNotifier<UiState> uiState) async {
    uiState.value = UiState.loading();
    final signInNotifier = ref.read(signInProvider.notifier);
    final result = await signInNotifier.signIn(email: email, password: password);

    if (context.mounted) {
      uiState.value = result;
      switch (result.state) {
        case UiStates.success:
          context.goNamed(OpRoutes.home.name);
          break;
        case UiStates.failed:
          showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: const Text("Sign in unsuccessful"),
              content: Text(result.message ?? "Please check your credentials and try again."),
              actions: <Widget>[
                PlatformDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
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
    final (
      emailController,
      passwordController,
      showPassword,
      formKey,
      isFormValid,
      emailValidationMode,
      passwordValidationMode
    ) = _useFormState();

    final uiState = useState<UiState>(UiState.initialized());

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
          onPressed: isFormValid.value && uiState.value.state != UiStates.loading
              ? () => _handleSignIn(
                    context,
                    ref,
                    emailController.text,
                    passwordController.text,
            uiState,

          )
              : null,
          child: uiState.value.state == UiStates.loading
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
    useTextEditingController();
    final passwordController = useTextEditingController();
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
}
