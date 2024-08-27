import 'dart:async';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_update.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';

part 'stock_market_provider.g.dart';

@riverpod
class StockMarket extends _$StockMarket {
  late final StockRepository _repository;
  StreamSubscription<StockUpdate>? _subscription;

  @override
  Future<StockMarketModel> build() async {
    _repository = ref.read(stockRepositoryProvider);
    
    ref.onDispose(() {
      _subscription?.cancel();
    });

    final initialData = await _repository.fetchStockMarketOverview();
    _listenToUpdates(initialData);
    return initialData;
  }

  void _listenToUpdates(StockMarketModel initialData) {
    _subscription?.cancel();
    _subscription = _repository.getStockUpdates().listen(
      (update) {
        print("Received update: $update"); // Debug print
        final updatedModel = _updateStockMarketModel(state.value ?? initialData, update);
        print("Updated model: $updatedModel"); // Debug print
        state = AsyncData(updatedModel);
      },
      onError: (error, stack) {
        print("Error in stream: $error"); // Debug print
        state = AsyncError(error, stack);
      },
    );
  }

  StockMarketModel _updateStockMarketModel(StockMarketModel currentModel, StockUpdate update) {
    return update.map(
      fullUpdate: (fullUpdate) => StockMarketModel(
        indexes: fullUpdate.indexes,
        topDecrease: fullUpdate.topDecrease,
        topIncrease: fullUpdate.topIncrease,
        topVolume: fullUpdate.topVolume,
      ),
      indexUpdate: (indexUpdate) {
        final updatedIndexes = currentModel.indexes.map((index) {
          return index.indexId == indexUpdate.data.indexId ? indexUpdate.data : index;
        }).toList();
        return currentModel.copyWith(indexes: updatedIndexes);
      },
      stockUpdate: (stockUpdate) {
        final updatedTopDecrease = _updateStockList(currentModel.topDecrease, stockUpdate.data);
        final updatedTopIncrease = _updateStockList(currentModel.topIncrease, stockUpdate.data);
        final updatedTopVolume = _updateStockList(currentModel.topVolume, stockUpdate.data);
        
        return currentModel.copyWith(
          topDecrease: updatedTopDecrease,
          topIncrease: updatedTopIncrease,
          topVolume: updatedTopVolume,
        );
      },
    );
  }

  List<StockModel> _updateStockList(List<StockModel> stocks, StockModel updatedStock) {
    return stocks.map((stock) {
      return stock.symbol == updatedStock.symbol ? updatedStock : stock;
    }).toList();
  }

  Future<void> refreshStockMarketOverview() async {
    state = const AsyncLoading();
    try {
      final latestData = await _repository.fetchStockMarketOverview();
      state = AsyncData(latestData);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}