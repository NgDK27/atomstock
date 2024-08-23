import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';

class ChatInput extends HookWidget {
  final void Function(String) onSend;
  final bool isWaitingForResponse;

  const ChatInput({
    super.key,
    required this.onSend,
    required this.isWaitingForResponse,
  });

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    return BottomBar(
      child: Row(
        children: [
          Expanded(
            child: PlatformTextField(
              controller: textController,
              hintText: "How can your AI Advisor help?",
              autocorrect: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.send,
              onEditingComplete: () {
                onSend(textController.text);
                textController.clear();
              },
              material: (_, __) => MaterialTextFieldData(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpRadius.xl),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: OpSpacing.md,
                    vertical: OpSpacing.sm,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      onSend(textController.text);
                      textController.clear();
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(
                       Icons.send,
                      weight: 800,
                      size: 28,
                    ),
                  ),
                  suffixIconColor: isWaitingForResponse ? Theme.of(context).colorScheme.surfaceContainerHigh : Theme.of(context).colorScheme.primary,
                ),
              ),
              cupertino: (_, __) => CupertinoTextFieldData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(OpRadius.lg),
                  border: Border.all(
                    color: OpDynamicColor.onSurfaceVariant(context)
                        .withOpacity(OpOpacity.tertiary),
                  ),
                ),
                suffix: PlatformIconButton(
                  onPressed: () {
                    onSend(textController.text);
                    textController.clear();
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    CupertinoIcons.arrow_up_circle_fill,
                      color: isWaitingForResponse ? OpDynamicColor.surfaceContainerHigh(context) : OpDynamicColor.primary(context),
                  ),

                ),
                suffixMode: OverlayVisibilityMode.always,
                padding: EdgeInsets.symmetric(
                  horizontal: OpSpacing.sm,
                  vertical: OpSpacing.xs,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}