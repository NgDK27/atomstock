import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class HomeOutlined extends IconBase {
  const HomeOutlined({super.key, super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 21">
  <path d="M11.875 1.234a.996.996 0 0 1 1.21 0l10.313 8.75c.391.352.47.938.118 1.329a.974.974 0 0 1-1.328.117l-.938-.82v7.265A3.11 3.11 0 0 1 18.125 21H6.875c-1.758 0-3.125-1.367-3.125-3.125v-7.266l-.977.82a.974.974 0 0 1-1.328-.117.974.974 0 0 1 .117-1.328l10.313-8.75Zm.625 1.954-6.875 5.82v8.867c0 .703.547 1.25 1.25 1.25H8.75v-5.938c0-.859.664-1.562 1.563-1.562h4.374c.86 0 1.563.703 1.563 1.563v5.937h1.875c.664 0 1.25-.547 1.25-1.25V9.008L12.5 3.188Zm-1.875 15.937h3.75V13.5h-3.75v5.625Z"/>
</svg>''';

  @override
  HomeOutlined copyWith({Color? color}) {
    return HomeOutlined(
      color: color ?? this.color,
    );
  }
}
