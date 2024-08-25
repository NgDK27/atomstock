import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/domain/models/status/ui_state.dart';
import 'package:oppenhomies/domain/models/status/ui_states_enum.dart';
import 'package:oppenhomies/domain/providers/auth/sign_up_provider.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/primary/filled_primary_button.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/textfields/platform_animated_text_form_field.dart';

class SignUp extends HookConsumerWidget {
  const SignUp({super.key});

  Future<void> _handleSignUp(BuildContext context, WidgetRef ref, String email,
      String password, ValueNotifier<UiState> uiState) async {
    uiState.value = UiState.loading();
    final signUpNotifier = ref.read(signUpProvider.notifier);
    final result =
        await signUpNotifier.signUp(tempEmail: email, tempPassword: password);

    if (context.mounted) {
      uiState.value = result.uiState;
      switch (result.uiState.state) {
        case UiStates.success:
          context.goNamed(OpRoutes.signUpVerify.name);
          break;
        case UiStates.failed:
          showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: const Text("Sign up unsuccessful"),
              content: Text(result.uiState.message ??
                  "Please check your credentials and try again."),
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
    final (
      emailController,
      passwordController,
      nameController,
      showPassword,
      formKey,
      isFormValid,
      emailValidationMode,
      passwordValidationMode,
      nameValidationMode
    ) = _useFormState();

    final uiState = useState<UiState>(UiState.initialized());

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
                          validator: AuthenticationValidator.fullNameValidator,
                          hintText: AutofillHints.name.sentenceCase(),
                          autofillHints: const [AutofillHints.name],
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
                          validator: AuthenticationValidator.emailValidator,
                          hintText: AutofillHints.email.sentenceCase(),
                          autofillHints: const [AutofillHints.email],
                        ).animated(),
                        const SizedBox(height: OpSpacing.xs),
                        Text(
                          "We'll send a verification code to this email address",
                          style: OpTextStyle.labelMedium(context)?.copyWith(
                            color: OpDynamicColor.onSurfaceVariant(context),
                          ),
                          textAlign: TextAlign.start,
                        ),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      floatingBottomWidget: BottomBar(
        child: OpFilledPrimaryButton(
          text: "Sign up",
          onPressed:
              isFormValid.value && uiState.value.state != UiStates.loading
                  ? () => _handleSignUp(
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
    TextEditingController,
    ValueNotifier<bool>,
    GlobalKey<FormState>,
    ValueNotifier<bool>,
    ValueNotifier<AutovalidateMode>,
    ValueNotifier<AutovalidateMode>,
    ValueNotifier<AutovalidateMode>
  ) _useFormState() {
    final emailController =
        useTextEditingController(text: "work@quanhoangdo.com");
    final passwordController = useTextEditingController(text: "abcABC123!@#");
    final nameController = useTextEditingController(text: "Quan Do");
    final showPassword = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);
    final emailValidationMode = useState(AutovalidateMode.disabled);
    final passwordValidationMode = useState(AutovalidateMode.disabled);
    final nameValidationMode = useState(AutovalidateMode.disabled);

    _useValidation(
      emailController: emailController,
      passwordController: passwordController,
      nameController: nameController,
      emailValidationMode: emailValidationMode,
      passwordValidationMode: passwordValidationMode,
      nameValidationMode: nameValidationMode,
      isFormValid: isFormValid,
      formKey: formKey,
    );

    return (
      emailController,
      passwordController,
      nameController,
      showPassword,
      formKey,
      isFormValid,
      emailValidationMode,
      passwordValidationMode,
      nameValidationMode
    );
  }

  void _useValidation({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required ValueNotifier<AutovalidateMode> emailValidationMode,
    required ValueNotifier<AutovalidateMode> passwordValidationMode,
    required ValueNotifier<AutovalidateMode> nameValidationMode,
    required ValueNotifier<bool> isFormValid,
    required GlobalKey<FormState> formKey,
  }) {
    const int validationDelay = 2;

    final email = useValueListenable(emailController);
    final password = useValueListenable(passwordController);
    final name = useValueListenable(nameController);

    final emailDebounced =
        useDebounced(email.text, const Duration(seconds: validationDelay));
    final passwordDebounced =
        useDebounced(password.text, const Duration(seconds: validationDelay));
    final nameDebounced =
        useDebounced(name.text, const Duration(seconds: validationDelay));

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
      if (nameDebounced?.isNotEmpty == true) {
        nameValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [nameDebounced]);

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
    }, [email, password, name]);
  }
}
