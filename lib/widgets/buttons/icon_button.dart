import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class OpIconButton extends HookWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;

  const OpIconButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = useState(OpDynamicColor.primary(context));

    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            PlatformIconButton(
              icon: Icon(
                icon,
                color: platformThemeData(
                  context,
                  material: (_) => null,
                  cupertino: (_) => OpDynamicColor.onPrimaryContainer(context),
                ),
              ),
              color: OpDynamicColor.primaryContainer(context),
              padding: const EdgeInsets.all(OpSpacing.sm),
              onPressed: onPressed,
              material: (_, __) => MaterialIconButtonData(
                color: OpDynamicColor.primary(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    OpDynamicColor.primaryContainer(context),
                  ),
                ),
              ),
              cupertino: (_, __) => CupertinoIconButtonData(
                color: OpDynamicColor.primaryContainer(context),
                borderRadius: const BorderRadius.all(Radius.circular(OpRadius.full)),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: OpSpacing.sm,
              vertical: OpSpacing.xs,
            ),
            child: Text(
              text,
              style: OpTextStyle.labelMediumProminent(context).bold().copyWith(
                    color: textColor.value,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
