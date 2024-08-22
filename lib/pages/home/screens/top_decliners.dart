import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class TopDecliners extends HookConsumerWidget {
  const TopDecliners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpPlatformSliverScaffold(title: "Top Decliners Today", slivers: []);
  }
}
