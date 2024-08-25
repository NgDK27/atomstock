import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oppenhomies/styles/colors.dart';

class NewChatButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NewChatButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      onPressed: onPressed,
      cupertino: (_, __) => CupertinoIconButtonData(
        padding: EdgeInsets.zero,
      ),
      icon: Icon(
        platformThemeData(
          context,
          material: (_) => Symbols.add,
          cupertino: (_) => CupertinoIcons.add,
        ),
        size: platformThemeData(
          context,
          material: (_) => 28,
          cupertino: (_) => 24,
        ),
        color: platformThemeData(
          context,
          material: (_) => null,
          cupertino: (_) => OpDynamicColor.onSurface(context),
        ),
      ),
    );
  }
}