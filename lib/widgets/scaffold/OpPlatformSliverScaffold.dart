import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles/spacings.dart';
import '../app_bars/OpAppBar.dart';

class OpPlatformSliverScaffold extends ConsumerWidget {
  final String title;
  final Widget sliver;

  const OpPlatformSliverScaffold({super.key, required this.sliver, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        color: platformThemeData(
          context,
          material: (ThemeData data) => data.colorScheme.surface,
          cupertino: (CupertinoThemeData data) => data.scaffoldBackgroundColor,
        ),
        child: CustomScrollView(
          slivers: [
            OpPlatformSliverAppBar(title: title),
            SliverSafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(
                    OpSpacing.md, OpSpacing.md, OpSpacing.md, 0),
                sliver: sliver)
          ],
        ));
  }
}
