import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';

class SimpleRow extends HookWidget {
  final String label;
  final double? value;

  const SimpleRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: OpSpacing.sm,
      runSpacing: OpSpacing.xs3,
      children: [
        Text(label, style: OpTextStyle.labelLarge(context),),
        Text(value?.vndNoSymbolFormat() ?? '-', style: OpTextStyle.labelLarge(context).bold(),),
      ],
    );
  }
}
