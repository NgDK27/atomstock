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


class InputNewEmail extends HookWidget {
  const InputNewEmail({super.key});

  void handleSignUp(
      BuildContext context, String email) {
    // Optional: Log to console
    if (kDebugMode) {
      print(
        'Sign up attempted - Email: $email');
    }

    context.goNamed(OpRoutes.verifyNewEmail.name);
  }

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();

    final email = useValueListenable(emailController);


    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);

    const int validationDelay = 2;

    final emailValidationMode = useState(AutovalidateMode.disabled);
    final emailDebounced =
    useDebounced(email.text, const Duration(seconds: validationDelay));

    useEffect(() {
      if (emailDebounced?.isNotEmpty == true) {
        emailValidationMode.value = AutovalidateMode.always;
      }
      return null;
    }, [emailDebounced],);


    useEffect(() {
      if (email.text.isNotEmpty
         ) {
        final isValid = formKey.currentState?.validate() ?? false;
        isFormValid.value = isValid;
      } else {
        isFormValid.value = false;
      }
      return null;
    }, [email],);

    return OpPlatformSliverScaffold(
      scrollable: true,
      title: "New email",
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

                      ],
                    ),
                  ),),
              ],
            ),
          ),),
      ],
      floatingBottomWidget: BottomBar(
        child: OpFilledPrimaryButton(
          text: "Continue",
          onPressed: isFormValid.value
              ? () => handleSignUp(context, emailController.text)
              : null,
        ),),);
  }
}
