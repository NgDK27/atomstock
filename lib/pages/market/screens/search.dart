import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';

class Search extends ConsumerWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
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
                          hintText: "Search for stocks and indexes",
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
              return StockListTile(stock: StockModel.sample());
            },
            itemCount: 20,
          ),
        )
      ],
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
