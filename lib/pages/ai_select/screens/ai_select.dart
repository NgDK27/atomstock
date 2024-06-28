import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/pages/ai_select/layouts/ai_select_card.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';

class AiSelect extends ConsumerWidget {
  const AiSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Column(
          children: [
            // TODO Add nav bar
            Text("Which AI Advisor matches your vibe?"
            // TODO Add style
            ),
            AiSelectCard(),
            // TODO Add horizontal scroll indicator
            OpFilledGlowPrimaryButton(text: "Select"
            // TODO Customize the text here
            )
          ],
        )
      ],
    );
  }
}
