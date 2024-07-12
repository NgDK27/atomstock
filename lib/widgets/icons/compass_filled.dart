import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class CompassFilled extends IconBase {
  const CompassFilled({super.key, super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 20">
  <path d="M12.5 20c-3.594 0-6.875-1.875-8.672-5-1.797-3.086-1.797-6.875 0-10C5.625 1.914 8.906 0 12.5 0c3.555 0 6.836 1.914 8.633 5 1.797 3.125 1.797 6.914 0 10a9.926 9.926 0 0 1-8.633 5Zm1.953-7.266c.352-.156.586-.39.742-.742l2.149-5.625a.922.922 0 0 0-1.211-1.21l-5.625 2.148c-.352.156-.586.39-.742.742l-2.149 5.625c-.312.742.469 1.523 1.211 1.21l5.625-2.148ZM13.75 10c0 .703-.586 1.25-1.25 1.25-.703 0-1.25-.547-1.25-1.25 0-.664.547-1.25 1.25-1.25.664 0 1.25.586 1.25 1.25Z"/>
</svg>''';

  @override
  CompassFilled copyWith({Color? color}) {
    return CompassFilled(
      color: color ?? this.color,
    );
  }
}
