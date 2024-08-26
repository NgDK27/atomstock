import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_market_top_decliners_provider.g.dart';

@riverpod
class StockMarketTopDecliners extends _$StockMarketTopDecliners {
  late final StockRepository _repository;

  @override
  Future<StockMarketStocksModel> build() async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchStockMarketTopDecliners();
  }

  Future<StockMarketStocksModel> _fetchStockMarketTopDecliners() async {
    return await _repository.fetchStockMarketTopDecrease();
  }

  Future<void> refreshStockMarketTopDecliners() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStockMarketTopDecliners());
  }
}
