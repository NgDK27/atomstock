import 'package:oppenhomies/domain/models/stock/stock_market_indexes_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/providers/stock/stock_repository.dart';

part 'stock_market_indexes_provider.g.dart';

@riverpod
class StockMarketIndexes extends _$StockMarketIndexes {
  late final StockRepository _repository;

  @override
  Future<StockMarketIndexesModel> build() async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchStockMarketIndexes();
  }

  Future<StockMarketIndexesModel> _fetchStockMarketIndexes() async {
    return await _repository.fetchStockMarketIndexes();
  }

  Future<void> refreshStockMarketIndexes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStockMarketIndexes());
  }
}