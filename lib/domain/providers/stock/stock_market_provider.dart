import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/models/stock/stock_market_model.dart';
import 'package:oppenhomies/domain/providers/stock/stock_repository.dart';

part 'stock_market_provider.g.dart';

@riverpod
class StockMarket extends _$StockMarket {
  late final StockRepository _repository;

  @override
  Future<StockMarketModel> build() async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchStockMarketOverview();
  }

  Future<StockMarketModel> _fetchStockMarketOverview() async {
    return await _repository.fetchStockMarketOverview();
  }

  Future<void> refreshStockMarketOverview() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStockMarketOverview());
  }
}