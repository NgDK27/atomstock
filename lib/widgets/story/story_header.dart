import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';

import '../../styles/colors.dart';

class StoryHeader extends ConsumerStatefulWidget {
  const StoryHeader({super.key});

  @override
  ConsumerState createState() => _StoryHeaderState();
}

class _StoryHeaderState extends ConsumerState<StoryHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Row(
        children: [
          // LinearProgressIndicator(
          // ),
        ],
      ),

      Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: OpColor.aqua60.withOpacity(OpOpacity.tertiary),
                borderRadius:
                const BorderRadius.all(Radius.circular(OpRadius.xs))),
            child: Padding(
              padding: const EdgeInsets.all(4), // Adjust this value as needed
              child: Image.asset('assets/images/app_icon.png'),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Atomstock",
            style: platformThemeData(context,
                material: (ThemeData data) => data.textTheme.labelMedium,
                cupertino: (CupertinoThemeData data) => data.textTheme.textStyle
                    .copyWith(
                    fontVariations: [const FontVariation.weight(600)])),
          )
        ],
      ),
    ]);
  }
}
