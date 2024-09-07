import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_market_top_performers_provider.g.dart';

@riverpod
class StockMarketTopPerformers extends _$StockMarketTopPerformers {
  late final StockRepository _repository;

  @override
  Future<StockMarketStocksModel> build() async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchStockMarketTopPerformers();
  }

  Future<StockMarketStocksModel> _fetchStockMarketTopPerformers() async {
    return await _repository.fetchStockMarketTopIncrease();
  }

  Future<void> refreshStockMarketTopPerformers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStockMarketTopPerformers());
  }
}
