import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class OpPlatformEdgeToEdgeScaffold extends ConsumerWidget {
  final VoidCallback? leadingNavigation;
  final Widget child;

  const OpPlatformEdgeToEdgeScaffold(
      {super.key, this.leadingNavigation, required this.child,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidgetBuilder(
        material: (_, child, __) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              extendBodyBehindAppBar: true,
              body: child,
            ),
        cupertino: (_, child, __) => CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                border:
                    Border(bottom: BorderSide(color: Colors.transparent)),
                padding: EdgeInsetsDirectional.zero,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
              ),
              child: child!,
            ),
        child: child,);
  }
}
