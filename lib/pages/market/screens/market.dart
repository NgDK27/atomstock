import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oppenhomies/navigation/routes.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class Market extends ConsumerWidget {
  const Market({super.key});

  void navigateMarketSearch(BuildContext context) {
    context.goNamed(OpRoutes.search.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpPlatformSliverScaffold(
      title: "Explore",
      transitionBetweenRoutes: false,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
                child: PlatformWidget(
                  cupertino: (_, __) => CupertinoSearchTextField(
                    placeholder: "Search for stocks and indexes",
                    onTap: () => navigateMarketSearch(context),
                  ),
                  material: (_, __) => SearchBar(
                    leading: const Padding(
                      padding: EdgeInsets.only(left: OpSpacing.xs),
                      child: Icon(Icons.search),
                    ),
                    hintText: "Search for stocks and indexes",
                    elevation: const WidgetStatePropertyAll(0),
                    onTap: () => navigateMarketSearch(context),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
