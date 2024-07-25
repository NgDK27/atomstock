import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/spacings.dart';

class OpPlatformSliverAppBar extends HookWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final bool transitionBetweenRoutes;

  const OpPlatformSliverAppBar({super.key, required this.title, this.leading, this.trailing, this.transitionBetweenRoutes = true});

  @override
  Widget build(BuildContext context) {
    final borderAnimation = useAnimationController(
      duration: const Duration(milliseconds: 50),
    );

    return PlatformWidget(
      material: (_, __) => SliverAppBar.large(
        title: Text(title),
        centerTitle: true,
        leading: leading,
        actions: trailing != null ? [
          trailing!,
        ] : [],
        automaticallyImplyLeading: true,
      ),
      cupertino: (_, __) => SliverLayoutBuilder(
        builder: (BuildContext context, SliverConstraints constraints) {
          final double expandedHeight =
              MediaQuery.of(context).padding.top + kBottomNavigationBarHeight;

          final bool isCollapsed = constraints.scrollOffset >=
              expandedHeight - kBottomNavigationBarHeight;

          if (isCollapsed) {
            borderAnimation.forward();
          } else {
            borderAnimation.reverse();
          }

          return AnimatedBuilder(
            animation: borderAnimation,
            builder: (context, child) {
              return CupertinoSliverNavigationBar(
                transitionBetweenRoutes: transitionBetweenRoutes,
                largeTitle: Text(title),
                border: Border(
                  bottom: BorderSide(
                    color: Color.lerp(
                      Colors.transparent,
                      CupertinoColors.separator.withOpacity(0.2),
                      borderAnimation.value,
                    )!,
                  ),
                ),
                stretch: true,
                leading: leading,
                trailing: trailing,
                padding: EdgeInsetsDirectional.symmetric(horizontal: OpSpacing.xs),
                automaticallyImplyLeading: true,
              );
            },
          );
        },
      ),
    );
  }
}
