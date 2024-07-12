import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class CompassOutlined extends IconBase {
  const CompassOutlined({super.key,  super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 22">
  <path d="M20.625 11c0-2.89-1.563-5.547-4.063-7.031-2.539-1.446-5.625-1.446-8.125 0C5.899 5.453 4.375 8.109 4.375 11a8.134 8.134 0 0 0 4.063 7.07c2.5 1.446 5.585 1.446 8.124 0 2.5-1.484 4.063-4.14 4.063-7.07ZM2.5 11a9.926 9.926 0 0 1 5-8.633c3.086-1.797 6.875-1.797 10 0 3.086 1.797 5 5.078 5 8.633 0 3.594-1.914 6.875-5 8.672-3.125 1.797-6.914 1.797-10 0-3.125-1.797-5-5.078-5-8.672Zm11.953 2.734-5.625 2.149c-.742.312-1.523-.469-1.21-1.211l2.148-5.625c.156-.352.39-.586.742-.742l5.625-2.149a.922.922 0 0 1 1.21 1.211l-2.148 5.625c-.156.352-.39.586-.742.742ZM13.75 11c0-.664-.586-1.25-1.25-1.25-.703 0-1.25.586-1.25 1.25 0 .703.547 1.25 1.25 1.25.664 0 1.25-.547 1.25-1.25Z"/>
</svg>''';

  @override
  CompassOutlined copyWith({Color? color}) {
    return CompassOutlined(
      color: color ?? this.color,
    );
  }
}
