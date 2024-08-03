import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/helpers/validators.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/neutral/OpFilledNeutralButton.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/textfields/platform_animated_text_form_field.dart';

class YourName extends HookConsumerWidget {
  const YourName({super.key});

  void handleNameUpdate(
      BuildContext context, String name,) {
    // Optional: Log to console
    if (kDebugMode) {
      print(
        'Name update attempted - Name: $name',);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Update with the name from account
    const originalName = "Charlize Theoron";

    final nameController = useTextEditingController(text: originalName);

    final name = useValueListenable(nameController);

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isFormValid = useState(false);

    const int validationDelay = 2;

    final nameValidationMode = useState(AutovalidateMode.disabled);
    final nameDebounced =
        useDebounced(name.text, const Duration(seconds: validationDelay));

    useEffect(
      () {
        if (nameDebounced?.isNotEmpty == true) {
          nameValidationMode.value = AutovalidateMode.always;
        }
        return null;
      },
      [nameDebounced],
    );

    useEffect(
      () {
        if (name.text.isNotEmpty) {
          final isValid = formKey.currentState?.validate() ?? false;
          isFormValid.value = isValid;
        } else {
          isFormValid.value = false;
        }
        return null;
      },
      [name],
    );

    return OpPlatformSliverScaffold(
      title: "Your Name",
      slivers: [
        SliverSafeArea(
          top: false,
          minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
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
                        validator: (value) => AuthenticationValidator.updateFullNameValidator(value, originalName: originalName),                        hintText: AutofillHints.name.sentenceCase(),
                        autofillHints: const [
                          AutofillHints.name,
                        ],
                      ).animated(),
                      const SizedBox(height: OpSpacing.md),
                    ],
                  ),
                )
              ),
            ]),
          ),
        ),
      ],
      floatingBottomWidget: BottomBar(
        child: OpFilledNeutralButton(
          text: "Save",
          onPressed: isFormValid.value
              ? () => handleNameUpdate(context, nameController.text,)
              : null,
        ),
      ),
    );
  }
}
