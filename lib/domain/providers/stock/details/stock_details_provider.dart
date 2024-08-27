import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_details_provider.g.dart';

@riverpod
class StockDetails extends _$StockDetails {
  late final StockRepository _repository;

  @override
  Future<StockModel> build(String identifier, StockItemType type) async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchDetails(
        identifier: identifier,
        type: type,
        timeRange: StockPriceDateFilter.oneDay,);
  }

  Future<StockModel> _fetchStockDetails(
      {required String symbol,
      required StockPriceDateFilter? timeRange,}) async {
    return await _repository.fetchStockDetails(
        symbol: symbol, timeRange: timeRange?.serverParameter,);
  }

  Future<StockModel> _fetchIndexDetails(
      {required String id, required StockPriceDateFilter? timeRange,}) async {
    StockModel stockFromIndex = await _repository.fetchIndexDetails(
        id: id, timeRange: timeRange?.serverParameter,);
    return stockFromIndex;
  }

  Future<StockModel> _fetchDetails({
    required String identifier,
    required StockItemType type,
    required StockPriceDateFilter? timeRange,
  }) async {
    switch (type) {
      case StockItemType.idx:
        return await _fetchIndexDetails(id: identifier, timeRange: timeRange);
      case StockItemType.stock:
        return await _fetchStockDetails(
            symbol: identifier, timeRange: timeRange,);
    }
  }

  Future<void> updateDetailsWithTimeRange(
      {required StockPriceDateFilter timeRange,}) async {
    switch (type) {
      case StockItemType.idx:
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchDetails(
            identifier: identifier, type: type, timeRange: timeRange,),);
        break;
      case StockItemType.stock:
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchDetails(
            identifier: identifier, type: type, timeRange: timeRange,),);
    }
  }
//
// Future<void> refreshStockDetails(
//     String identifier, StockItemType type, StockPriceDateFilter timeRange) async {
//   state = const AsyncValue.loading();
//   state = await AsyncValue.guard(
//       () => _fetchDetails(identifier: identifier, type: type, timeRange: timeRange));
// }
}
