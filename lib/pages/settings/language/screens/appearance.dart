import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/helpers/string_extensions.dart';
import 'package:oppenhomies/domain/models/language/language_type.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

final currentLanguageProvider = StateProvider<LanguageType>((ref) {
  // TODO: Set a default value here, or load from persistent storage
  return LanguageType.enUS;
});

class Language extends HookConsumerWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);

    return OpPlatformSliverScaffold(
      title: "Language",
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              for (final value in LanguageType.values) ...[
                PlatformListTile(
                  title: Text(value.label.sentenceCase()),
                  onTap: () {
                    // Update the appearance when tapped
                    ref.read(currentLanguageProvider.notifier).state = value;
                  },
                  trailing: value == currentLanguage
                      ? Icon(PlatformIcons(context).checkMark)
                      : null,
                )
              ]
            ]),
          ),
        ),
      ],
    );
  }
}