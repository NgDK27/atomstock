import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class SuitcaseFilled extends IconBase {
  const SuitcaseFilled({super.key, super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg"  viewBox="0 0 25 20">
  <path d="M9.375 2.188V3.75h6.25V2.187a.336.336 0 0 0-.313-.312H9.689a.308.308 0 0 0-.313.313ZM7.5 3.75V2.187C7.5 1.016 8.477 0 9.688 0h5.624C16.485 0 17.5 1.016 17.5 2.188V3.75H20c1.367 0 2.5 1.133 2.5 2.5v10c0 1.406-1.133 2.5-2.5 2.5H5a2.468 2.468 0 0 1-2.5-2.5v-10c0-1.367 1.094-2.5 2.5-2.5h2.5Z"/>
</svg>''';

  @override
  SuitcaseFilled copyWith({Color? color}) {
    return SuitcaseFilled(
      color: color ?? this.color,
    );
  }
}
