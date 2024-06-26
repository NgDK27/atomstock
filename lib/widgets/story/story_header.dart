import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryHeader extends ConsumerStatefulWidget {
  const StoryHeader({super.key});

  @override
  ConsumerState createState() => _StoryHeaderState();
}

class _StoryHeaderState extends ConsumerState<StoryHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(),
      Row(
        children: [

        ],
      ),
    ]);
  }
}
