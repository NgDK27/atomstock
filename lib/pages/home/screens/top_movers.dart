import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class TopMovers extends HookConsumerWidget {
  const TopMovers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpPlatformSliverScaffold(title: "Top Movers Today", slivers: []);
  }
}
