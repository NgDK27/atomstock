import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class ResetPassword extends ConsumerWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const OpPlatformSliverScaffold(
      title: "Reset password",
      slivers: [
        SliverSafeArea(
            top: false,
            minimum: EdgeInsets.symmetric(horizontal: OpSpacing.md),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: OpSpacing.md),
                  Text("🚧 Work in progress")
                ],
              ),
            ))
      ],
    );
  }
}
