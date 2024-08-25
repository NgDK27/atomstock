import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class StockCollectionsLayout extends HookConsumerWidget {
  final String title;
  final List<StockModel>? stocks;

  const StockCollectionsLayout({super.key, required this.title, this.stocks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpPlatformSliverScaffold(
      title: title,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                PlatformWidget(
                  cupertino: (_, __) => const SizedBox(height: OpSpacing.sm),
                ),
                if (stocks != null)
                  ...stocks!.map((stock) => StockListTile(stock: stock))
                else
                  Text("No data"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
