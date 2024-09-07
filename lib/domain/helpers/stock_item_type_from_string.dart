import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';

extension StockItemTypeExtension on String {
  StockItemType? toStockItemType() {
    return StockItemType.values
        .where((type) => type.value == this)
        .firstOrNull;
  }
}