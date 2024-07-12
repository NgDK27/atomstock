import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class LightningFilled extends IconBase {
  const LightningFilled({super.key, super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 22">
  <path d="m17.383 2.758-3.008 7.031h4.375c.508 0 .977.313 1.172.781.156.508.039 1.055-.352 1.407l-10 8.75c-.468.351-1.093.39-1.562.039a1.214 1.214 0 0 1-.43-1.485l3.008-7.031H6.25c-.547 0-1.016-.313-1.172-.781-.195-.508-.078-1.055.313-1.406l10-8.75c.468-.352 1.093-.391 1.562-.04.469.313.664.938.43 1.485Z"/>
</svg>''';

  @override
  LightningFilled copyWith({Color? color}) {
    return LightningFilled(
      color: color ?? this.color,
    );
  }
}
