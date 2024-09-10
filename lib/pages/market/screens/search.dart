import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class Search extends ConsumerWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: OpDynamicColor.surface(context),
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // Header here
          SliverPersistentHeader(
            pinned: true,
            delegate: _MyHeaderDelegate(
              child: Container(
                color: OpDynamicColor.surface(context),
                child: SafeArea(
                  top: true,
                  bottom: false,
                  minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: PlatformWidget(
                          cupertino: (_, __) => CupertinoSearchTextField(
                            placeholder: "Search for stocks and indexes",
                            autofocus: true,
                            onTap: () {},
                          ),
                          material: (_, __) => SearchBar(
                            leading: BackButton(),
                            hintText: "Search for stocks",
                            elevation: const WidgetStatePropertyAll(0),
                            autoFocus: true,
                            onTap: () {},
                          ),
                        ),
                      ),
                      // iOS Done Button
                      PlatformWidget(
                        cupertino: (_, __) => PlatformTextButton(
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.fromLTRB(OpSpacing.md,
                              OpSpacing.none, OpSpacing.none, OpSpacing.none),
                          child: Text("Done"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              minHeight: 120,
              maxHeight: 120,
            ),
          ),

          // Body
          SliverSafeArea(
            top: false,
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: OpSpacing.md, vertical: OpSpacing.xl2),
                    child: Column(
                      children: [
                        Icon(
                          Symbols.search_rounded,
                          color: OpDynamicColor.onSurface(context)
                              .withOpacity(OpOpacity.secondary),
                          size: 48,
                          weight: 600,
                        ),
                        SizedBox(
                          height: OpSpacing.xs,
                        ),
                        Text(
                          "Search with a name or symbol",
                          style: OpTextStyle.body(context)?.copyWith(
                            color: OpDynamicColor.onSurface(context)
                                .withOpacity(OpOpacity.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 1,
            ),
          )
        ],
      ),
    );
  }
}

class _MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _MyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_MyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
