import 'package:flutter/material.dart';

import '../../styles/colors.dart';

class OpDividerVariant extends StatelessWidget {
  const OpDividerVariant({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: OpDynamicColor.outlineVariant(context),
    );
  }
}
