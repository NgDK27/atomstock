import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_explore.g.dart';

@Riverpod(keepAlive: true)
@riverpod
class StockExplore extends _$StockExplore {
  late final StockRepository _repository;

  @override
  Future<StockMarketStocksModel> build() async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchStockExplore();
  }

  Future<StockMarketStocksModel> _fetchStockExplore() async {
    return await _repository.fetchAllStocks();
  }

  Future<void> refreshStockExplore() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStockExplore());
  }
}
