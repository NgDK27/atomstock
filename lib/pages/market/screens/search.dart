import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/providers/stock/market/stock_search.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/effects.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Search extends HookConsumerWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = ref.watch(stockSearchProvider);
    final queryController = useTextEditingController();

    void handleQueryChange() {
      ref.read(stockSearchProvider.notifier).searchStock(queryController.text);
    }

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
                            controller: queryController,
                            placeholder: "Search for stocks",
                            autofocus: true,
                            onChanged: (_) => handleQueryChange(),
                          ),
                          material: (_, __) => SearchBar(
                            controller: queryController,
                            leading: BackButton(),
                            hintText: "Search for stocks",
                            elevation: const WidgetStatePropertyAll(0),
                            autoFocus: true,
                            onChanged: (_) => handleQueryChange(),
                          ),
                        ),
                      ),
                      // iOS Done Button
                      PlatformWidget(
                        cupertino: (_, __) => PlatformTextButton(
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.fromLTRB(OpSpacing.md,
                              OpSpacing.none, OpSpacing.none, OpSpacing.none,),
                          child: Text("Done"),
                        ),
                      ),
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
            sliver: queryController.text.isEmpty
                ? _searchPlaceholder(context)
                : searchResult.when(
                    data: (data) => data != null
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, idx) {
                                return StockListTile(
                                  stock: searchResult.requireValue!.stocks[idx],
                                );
                              },
                              childCount: (searchResult.hasValue
                                  ? searchResult.requireValue!.stocks.length
                                  : 10),
                            ),
                          )
                        : _searchNoResult(context),
                    error: (_, __) => _searchNoResult(context),
                    loading: () => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, idx) {
                          return Skeletonizer(
                            effect: opShimmerEffect(context),
                            child: StockListTile(
                              stock: StockModel.sample(),
                            ),
                          );
                        },
                        childCount: 10,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _searchPlaceholder(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: OpSpacing.md, vertical: OpSpacing.xl2,),
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
      ),
    );
  }

  Widget _searchNoResult(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: OpSpacing.md,
            vertical: OpSpacing.xl2,
          ),
          child: Column(
            children: [
              Icon(
                Symbols.search_off_rounded,
                color: OpDynamicColor.onSurface(context)
                    .withOpacity(OpOpacity.secondary),
                size: 48,
                weight: 600,
              ),
              SizedBox(
                height: OpSpacing.xs,
              ),
              Text(
                "No results found",
                style: OpTextStyle.body(context)?.copyWith(
                  color: OpDynamicColor.onSurface(context)
                      .withOpacity(OpOpacity.secondary),
                ),
              ),
            ],
          ),
        ),
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
      BuildContext context, double shrinkOffset, bool overlapsContent,) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_MyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
