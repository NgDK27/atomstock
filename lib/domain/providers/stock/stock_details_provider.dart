import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/providers/stock/stock_repository.dart';

part 'stock_details_provider.g.dart';

@riverpod
class StockDetails extends _$StockDetails {
  late final StockRepository _repository;

  @override
  Future<StockModel> build(String symbol) async {
    _repository = ref.read(stockRepositoryProvider);
    return _fetchStockDetails(symbol: symbol);
  }

  Future<StockModel> _fetchStockDetails({required String symbol}) async {
    return await _repository.fetchStockDetails(symbol: symbol);
  }

  Future<void> refreshStockDetails(String symbol) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStockDetails(symbol: symbol));
  }
}