import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpPlatformSliverAppBar extends ConsumerWidget {
  final String title;

  const OpPlatformSliverAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidget(
      material: (_, __) => SliverAppBar.large(
        title: Text(title),
        centerTitle: true,
      ),
      cupertino: (_, __) => CupertinoSliverNavigationBar(
        largeTitle: Text(title),
        stretch: true,
      ),
    );
  }
}
