import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/models/appearance/appearance_type.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

final currentAppearanceProvider = StateProvider<AppearanceType>((ref) {
  // TODO: Set a default value here, or load from persistent storage
  return AppearanceType.values.first;
});

class Appearance extends HookConsumerWidget {
  const Appearance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAppearance = ref.watch(currentAppearanceProvider);

    return OpPlatformSliverScaffold(
      title: "Appearance",
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              for (final value in AppearanceType.values) ...[
                PlatformListTile(
                  title: Text(value.label.sentenceCase()),
                  onTap: () {
                    // Update the appearance when tapped
                    ref.read(currentAppearanceProvider.notifier).state = value;
                  },
                  trailing: value == currentAppearance
                      ? Icon(PlatformIcons(context).checkMark)
                      : null,
                ),
              ],
            ]),
          ),
        ),
      ],
    );
  }
}