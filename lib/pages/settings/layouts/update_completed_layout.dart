import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/buttons/neutral/OpFilledNeutralButton.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class UpdateCompletedLayout extends StatelessWidget {
  final String updatedField;

  const UpdateCompletedLayout({super.key, required this.updatedField});

  @override
  Widget build(BuildContext context) {
    return OpPlatformSliverScaffold(
      title: "$updatedField update completed",
      slivers: [
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                OpFilledNeutralButton(
                  text: "Back to Settings",
                  onPressed: () => context.goNamed(OpRoutes.settings.name),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
