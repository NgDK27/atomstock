import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/app_bars/app_bar.dart';

class OpPlatformSliverScaffold extends HookWidget {
  final String title;
  final List<Widget> slivers;
  final bool transitionBetweenRoutes;
  final bool scrollable;
  final Widget? floatingBottomWidget;
  final Widget? topBarLeading;
  final Widget? topBarTrailing;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const OpPlatformSliverScaffold({
    super.key,
    required this.title,
    this.floatingBottomWidget,
    this.scrollable = true,
    this.topBarLeading,
    this.topBarTrailing,
    this.transitionBetweenRoutes = true,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    final floatingWidgetKey = useMemoized(() => GlobalKey());
    final floatingWidgetHeight = useState<double>(0);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (floatingBottomWidget != null) {
            final RenderBox? renderBox = floatingWidgetKey.currentContext
                ?.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              floatingWidgetHeight.value = renderBox.size.height;
            }
          }
        });
        return null;
      },
      [floatingBottomWidget],
    );

    return PlatformScaffold(
      body: Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: keyboardDismissBehavior,
            physics: scrollable ? null : const NeverScrollableScrollPhysics(),
            slivers: [
              OpPlatformSliverAppBar(
                title: title,
                leading: topBarLeading,
                trailing: topBarTrailing,
                transitionBetweenRoutes: transitionBetweenRoutes,
              ),
              if (isCupertino(context))
                const SliverToBoxAdapter(child: SizedBox(height: OpSpacing.sm)),
              ...slivers,
              SliverToBoxAdapter(
                child: SizedBox(height: floatingWidgetHeight.value),
              ),
            ],
          ),
          if (floatingBottomWidget != null)
            Positioned(
              key: floatingWidgetKey,
              bottom: 0,
              left: 0,
              right: 0,
              child: floatingBottomWidget!,
            ),
        ],
      ),
    );
  }
}
