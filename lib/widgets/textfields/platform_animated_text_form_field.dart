import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../styles/colors.dart';
import '../../styles/radius.dart';
// ... other imports

extension AnimatedPlatformTextFormFieldExtension on PlatformTextFormField {
  Widget animated({Duration duration = const Duration(milliseconds: 100)}) {
    return _AnimatedPlatformTextFormField(originalWidget: this, duration: duration);
  }
}

class _AnimatedPlatformTextFormField extends HookWidget {
  final PlatformTextFormField originalWidget;
  final Duration duration;

  const _AnimatedPlatformTextFormField({
    required this.originalWidget,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = originalWidget.focusNode ?? useFocusNode();
    final isFieldFocused = useState(false);
    final animationController = useAnimationController(duration: duration);

    useEffect(() {
      void listener() {
        isFieldFocused.value = focusNode.hasFocus;
        if (isFieldFocused.value) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      }
      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final borderColor = ColorTween(
          begin: OpDynamicColor.outlineVariant(context),
          end: OpDynamicColor.onSurface(context),
        ).evaluate(animationController);

        return PlatformTextFormField(
          // Copy over all the original widget's properties
          controller: originalWidget.controller,
          initialValue: originalWidget.initialValue,
          focusNode: focusNode,
          keyboardType: originalWidget.keyboardType,
          textCapitalization: originalWidget.textCapitalization,
          textInputAction: originalWidget.textInputAction,
          style: originalWidget.style,
          strutStyle: originalWidget.strutStyle,
          textAlign: originalWidget.textAlign,
          textAlignVertical: originalWidget.textAlignVertical,
          autofocus: originalWidget.autofocus,
          readOnly: originalWidget.readOnly,
          showCursor: originalWidget.showCursor,
          obscuringCharacter: originalWidget.obscuringCharacter,
          obscureText: originalWidget.obscureText,
          autocorrect: originalWidget.autocorrect,
          smartDashesType: originalWidget.smartDashesType,
          smartQuotesType: originalWidget.smartQuotesType,
          enableSuggestions: originalWidget.enableSuggestions,
          maxLines: originalWidget.maxLines,
          minLines: originalWidget.minLines,
          expands: originalWidget.expands,
          maxLength: originalWidget.maxLength,
          onChanged: originalWidget.onChanged,
          onTap: originalWidget.onTap,
          onEditingComplete: originalWidget.onEditingComplete,
          onFieldSubmitted: originalWidget.onFieldSubmitted,
          onSaved: originalWidget.onSaved,
          validator: originalWidget.validator,
          inputFormatters: originalWidget.inputFormatters,
          enabled: originalWidget.enabled,
          cursorWidth: originalWidget.cursorWidth,
          cursorHeight: originalWidget.cursorHeight,
          cursorColor: originalWidget.cursorColor,
          keyboardAppearance: originalWidget.keyboardAppearance,
          scrollPadding: originalWidget.scrollPadding,
          enableInteractiveSelection: originalWidget.enableInteractiveSelection,
          selectionControls: originalWidget.selectionControls,
          scrollPhysics: originalWidget.scrollPhysics,
          autofillHints: originalWidget.autofillHints,
          autovalidateMode: originalWidget.autovalidateMode,
          hintText: originalWidget.hintText,
          cupertino: (_, __) => CupertinoTextFormFieldData(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor!),
              borderRadius: const BorderRadius.all(Radius.circular(OpRadius.sm)),
            ),
          ),
        );
      },
    );
  }
}