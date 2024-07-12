import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class SparkleOutlined extends IconBase {
  const SparkleOutlined({super.key, super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 20">
  <path d="M12.5 1.25c.352 0 .664.234.82.547l2.344 5.039 5.04 2.344c.312.156.546.468.546.82a.96.96 0 0 1-.547.86l-5.039 2.343-2.344 5.04a.91.91 0 0 1-.82.507c-.39 0-.703-.195-.86-.508l-2.343-5.039-5.04-2.344c-.312-.156-.507-.468-.507-.859 0-.352.195-.664.508-.82l5.039-2.344 2.344-5.04a.96.96 0 0 1 .859-.546Zm0 3.203L10.86 7.93a.793.793 0 0 1-.47.468L6.915 10l3.477 1.64c.234.079.39.235.468.47l1.641 3.476 1.602-3.477a.704.704 0 0 1 .468-.468L18.047 10 14.57 8.398a.793.793 0 0 1-.468-.468L12.5 4.453Z"/>
</svg>''';

  @override
  SparkleOutlined copyWith({Color? color}) {
    return SparkleOutlined(
      color: color ?? this.color,
    );
  }
}
