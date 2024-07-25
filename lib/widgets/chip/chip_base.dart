import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles/colors.dart';
import '../../styles/opacities.dart';
import '../../styles/radius.dart';
import '../../styles/spacings.dart';
import '../../styles/text.dart';

abstract class ChipBase extends ConsumerWidget {
  final String text;

  const ChipBase({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: getColor(context),
          borderRadius: const BorderRadius.all(Radius.circular(OpRadius.full)),),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: OpSpacing.xs2, horizontal: OpSpacing.xs,),
        child: Text(
          text,
          style: getTextStyle(context),
        ),
      ),
    );
  }

  Color getColor(BuildContext context);

  TextStyle? getTextStyle(BuildContext context);
}

class ChipMediumPrimary extends ChipBase {
  const ChipMediumPrimary({super.key, required super.text});

  @override
  Color getColor(BuildContext context) =>
      OpDynamicColor.primaryContainer(context).withOpacity(OpOpacity.tertiary);

  @override
  TextStyle? getTextStyle(BuildContext context) =>
      OpTextStyle.labelMediumProminent(context)?.copyWith(
        color: OpDynamicColor.onPrimaryContainer(context),
      );
}

class ChipMediumNeutral extends ChipBase {
  const ChipMediumNeutral({super.key, required super.text});

  @override
  Color getColor(BuildContext context) =>
      OpDynamicColor.surfaceContainerHigh(context).withOpacity(OpOpacity.tertiary);

  @override
  TextStyle? getTextStyle(BuildContext context) =>
      OpTextStyle.labelMediumProminent(context)?.copyWith(
        color: OpDynamicColor.onPrimaryContainer(context),
      );
}

class ChipMediumAqua extends ChipBase {
  const ChipMediumAqua({super.key, required super.text});

  @override
  Color getColor(BuildContext context) => platformThemeData(context,
      material: (ThemeData data) => OpLightDarkColor.primary
          .harmonizeWith(data.colorScheme.primary)
          .withOpacity(OpOpacity.tertiary),
      cupertino: (_) =>
          OpDynamicColor.primary(context).withOpacity(OpOpacity.tertiary),);

  @override
  TextStyle? getTextStyle(BuildContext context) =>
      OpTextStyle.labelMediumProminent(context)?.copyWith(
        color: OpDynamicColor.onPrimaryContainer(context),
      );
}

class ChipMediumCherry extends ChipBase {
  const ChipMediumCherry({super.key, required super.text});

  @override
  Color getColor(BuildContext context) => platformThemeData(context,
      material: (ThemeData data) =>
          OpLightDarkColor.stockFall.harmonizeWith(data.colorScheme.primary),
      cupertino: (_) => OpDynamicColor.primary(context),); // TODO Fix

  @override
  TextStyle? getTextStyle(BuildContext context) =>
      OpTextStyle.labelMediumProminent(context)?.copyWith(
        color: OpDynamicColor.onPrimaryContainer(context),
      );
}
