import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/domain/models/contact_support/contact_support_type.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class ContactSupport extends HookWidget {
  const ContactSupport({super.key});

  void handleSubmit({
    required BuildContext context,
    required ContactSupportType type,
    required String details,
  }) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text("Support request submitted"),
        content: Text("Type: ${type.label},\nDetails: $details"),
        actions: [
          PlatformDialogAction(
            child: Text("OK"),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailController = useTextEditingController();
    final selectedSupportType = useState(ContactSupportType.bug);

    // Add a listener to rebuild when text changes
    useListenable(detailController);

    return OpPlatformSliverScaffold(
      title: "Contact support",
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      slivers: [
        SliverSafeArea(
          top: false,
          minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  "I am reaching out about...",
                  style: OpTextStyle.titleSmall(context),
                ),
                const SizedBox(height: OpSpacing.sm),
                for (final value in ContactSupportType.values) ...[
                  PlatformListTile(
                    title: Text(value.label),
                    subtitle: Text(value.supportingText),
                    onTap: () => selectedSupportType.value = value,
                    cupertino: (_, __) => CupertinoListTileData(
                        padding:
                            EdgeInsets.symmetric(horizontal: OpSpacing.none)),
                    trailing: value == selectedSupportType.value
                        ? Icon(PlatformIcons(context).checkMark)
                        : null,
                  ),
                  const SizedBox(height: OpSpacing.xs),
                ],
                const SizedBox(height: OpSpacing.md),
                Text(
                  "Be as detailed as you can",
                  style: OpTextStyle.titleSmall(context),
                ),
                const SizedBox(height: OpSpacing.sm),
                PlatformTextField(
                  controller: detailController,
                  minLines: 10,
                  maxLines: 10,
                  hintText: selectedSupportType.value.supportingText,
                  textAlignVertical: TextAlignVertical.top,
                  cupertino: (_, __) => CupertinoTextFieldData(),
                ),
              ],
            ),
          ),
        ),
      ],
      floatingBottomWidget: BottomBar(
        child: OpFilledGlowPrimaryButton(
          text: "Submit",
          onPressed: detailController.text.isNotEmpty
              ? () => handleSubmit(
                    context: context,
                    type: selectedSupportType.value,
                    details: detailController.text,
                  )
              : null,
        ),
      ),
    );
  }
}
