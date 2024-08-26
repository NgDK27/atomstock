import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';

part 'stock_details_time_range_provider.g.dart';

@riverpod
class StockDetailsTimeRange extends _$StockDetailsTimeRange {
  @override
  StockPriceDateFilter build() => StockPriceDateFilter.oneMonth;

  void updateTimeRange(StockPriceDateFilter newTimeRange) {
    state = newTimeRange;
  }
}
