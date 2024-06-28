import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/illustrations/light_bulb_illustration.dart';

class AiSelectCard extends ConsumerWidget {
  const AiSelectCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Stack(
        children: [
          Container(
            // TODO Add gradient widget
          ),
          Column(
            children: [
              Row(
                children: [
                  LightBulbIllustration(),
                  Container(// TODO Add chip widget
                      )
                ],
              ),
              Row(
                children: [
                  Icon(PlatformIcons(context).star),
                  Text("Slow and Steady")
                ],
              ),
              Text("Summary" // TODO Add style
                  ),
              Text("Bullet point"
                  // TODO Add content and style
                  ),
              Divider(),
              Text('78%' // TODO Add style
                  ),
              Text("Time" // TODO Add style
                  )
            ],
          )
        ],
      ),
    );
  }
}
