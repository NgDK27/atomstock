import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/list_tiles/index_list_tile.dart';
import 'package:oppenhomies/widgets/list_tiles/stock_list_tile.dart';
import 'package:oppenhomies/widgets/typography/title_large.dart';

Widget marketIndexList(
    {required String title,
      required Icon icon,
      required VoidCallback onPressed,
      required List<IndexModel> indexes}) {
  return Column(
    children: [
      OpTitleLarge(title, onPressed: onPressed, leading: icon),
      ...indexes.map((index) => IndexListTile(index: index)),
      const SizedBox(
        height: OpSpacing.lg,
      ),
    ],
  );
}

Widget marketStockList(
    {required String title,
      required Icon icon,
      required VoidCallback onPressed,
      required List<StockModel> stocks}) {
  return Column(
    children: [
      OpTitleLarge(title, onPressed: onPressed, leading: icon),
      ...stocks.map((stock) => StockListTile(stock: stock)),
      const SizedBox(
        height: OpSpacing.lg,
      ),
    ],
  );
}