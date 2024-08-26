import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_market_top_movers_provider.g.dart';

@riverpod
class StockMarketTopMovers extends _$StockMarketTopMovers {
  late final StockRepository _repository;

  @override
  Future<StockMarketStocksModel> build() async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchStockMarketTopMovers();
  }

  Future<StockMarketStocksModel> _fetchStockMarketTopMovers() async {
    return await _repository.fetchStockMarketTopVolume();
  }

  Future<void> refreshStockMarketTopMovers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStockMarketTopMovers());
  }
}
