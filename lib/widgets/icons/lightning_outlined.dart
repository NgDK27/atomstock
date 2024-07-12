import 'dart:ui';

import 'package:oppenhomies/widgets/icons/icon_base.dart';

class LightningOutlined extends IconBase {
  const LightningOutlined({super.key, super.color});

  @override
  String get iconString =>
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 20">
  <path d="M16.29 0c.741 0 1.288.742 1.093 1.445l-2.11 7.305h3.36c.742 0 1.328.625 1.328 1.367 0 .43-.156.781-.469 1.055L9.375 19.766a1.09 1.09 0 0 1-.703.234c-.742 0-1.29-.703-1.094-1.406l2.11-7.344H6.288A1.3 1.3 0 0 1 5 9.96c0-.39.156-.741.43-1.015L15.586.273c.195-.156.43-.273.703-.273Zm-1.407 3.32-7.07 6.055h3.125c.273 0 .546.156.742.39.156.235.234.547.156.82l-1.758 6.134 7.149-6.094h-3.165a.984.984 0 0 1-.78-.352c-.157-.234-.235-.546-.157-.82l1.758-6.133Z"/>
</svg>''';

  @override
  LightningOutlined copyWith({Color? color}) {
    return LightningOutlined(
      color: color ?? this.color,
    );
  }
}
