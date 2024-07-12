import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class HomeFilled extends IconBase {
  const HomeFilled({super.key, super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 20">
  <path d="M23.71 10c0 .703-.585 1.25-1.25 1.25h-1.25l.04 6.25v.938c0 .898-.703 1.562-1.563 1.562h-3.125C15.665 20 15 19.336 15 18.437V15c0-.664-.586-1.25-1.25-1.25h-2.5c-.703 0-1.25.586-1.25 1.25V18.438C10 19.335 9.297 20 8.437 20H5.313c-.899 0-1.563-.664-1.563-1.563V11.25H2.5c-.703 0-1.25-.547-1.25-1.25 0-.352.117-.664.39-.938l10-8.75C11.915.04 12.228 0 12.5 0s.586.078.82.273l9.961 8.79c.313.273.469.585.43.937Z"/>
</svg>''';

  @override
  HomeFilled copyWith({Color? color}) {
    return HomeFilled(
      color: color ?? this.color,
    );
  }
}
