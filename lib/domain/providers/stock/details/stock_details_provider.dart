import 'dart:async';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/models/stock/details_update.dart';
import 'package:oppenhomies/domain/models/stock/stock_change_enum.dart';  

part 'stock_details_provider.g.dart';

@riverpod
class StockDetails extends _$StockDetails {
  late final StockRepository _repository;
  StreamSubscription? _subscription;
  String? _currentEndpoint;

  @override
  Future<StockModel> build(String identifier, StockItemType type) async {
    _repository = ref.read(stockRepositoryProvider);

    ref.onDispose(() {
      _subscription?.cancel();
      if (_currentEndpoint != null) {
        _repository.disconnectWebSocket(_currentEndpoint!);
      }
    });

    final initialData = await _fetchDetails(
      identifier: identifier,
      type: type,
      timeRange: StockPriceDateFilter.oneDay,
    );
    _listenToUpdates(initialData, identifier, type);
    return initialData;
  }

  void _listenToUpdates(StockModel initialData, String identifier, StockItemType type) {
    _subscription?.cancel();
    if (_currentEndpoint != null) {
      _repository.disconnectWebSocket(_currentEndpoint!);
    }
    _currentEndpoint = type == StockItemType.stock
        ? '/ws/stock/$identifier'
        : '/ws/index/$identifier';

    _subscription = (type == StockItemType.stock
        ? _repository.getStockDetailUpdates(identifier)
        : _repository.getIndexDetailUpdates(identifier))
      .listen(
        (update) {
          print("Received parsed update in provider: $update");
          final updatedModel = _updateStockModel(state.value ?? initialData, update);
       
          state = AsyncData(updatedModel);
        },
        onError: (error, stack) {
          state = AsyncError(error, stack);
        },
      );
  }
  
  StockModel _updateStockModel(StockModel currentModel, dynamic update) {
    if (update is StockDetailUpdate) {
      return _updateStockData(currentModel, update);
    } else if (update is IndexDetailUpdate) {
      return _updateIndexData(currentModel, update);
    }
    return currentModel;
  }

  StockModel _updateStockData(StockModel currentModel, StockDetailUpdate update) {
    StockChange? change;
    if (update.currentPrice > currentModel.currentPrice) {
      change = StockChange.increase;
    } else if (update.currentPrice < currentModel.currentPrice) {
      change = StockChange.decrease;
    }

    return currentModel.copyWith(
      currentPrice: update.currentPrice,
      priceChange: update.priceChange,
      percentChange: update.percentChange,
      totalVolume: update.volume,
      change: change,
    );
  }

  StockModel _updateIndexData(StockModel currentModel, IndexDetailUpdate update) {
    StockChange? change;
    if (update.indexValue > currentModel.currentPrice) {
      change = StockChange.increase;
    } else if (update.indexValue < currentModel.currentPrice) {
      change = StockChange.decrease;
    }

    return currentModel.copyWith(
      currentPrice: update.indexValue,
      priceChange: update.change,
      percentChange: update.percentChange,
      totalVolume: update.totalQtty?.toDouble() ?? currentModel.totalVolume,
      totalValue: update.totalValue,
      change: change,
    );
  }

  Future<StockModel> _fetchDetails({
    required String identifier,
    required StockItemType type,
    required StockPriceDateFilter timeRange,
  }) async {
    switch (type) {
      case StockItemType.idx:
        return await _repository.fetchIndexDetails(id: identifier, timeRange: timeRange.serverParameter);
      case StockItemType.stock:
        return await _repository.fetchStockDetails(symbol: identifier, timeRange: timeRange.serverParameter);
    }
  }

  Future<void> updateDetailsWithTimeRange({required StockPriceDateFilter timeRange}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchDetails(
      identifier: identifier,
      type: type,
      timeRange: timeRange,
    ),);
    _listenToUpdates(state.value!, identifier, type);
  }
//
// Future<void> refreshStockDetails(
//     String identifier, StockItemType type, StockPriceDateFilter timeRange) async {
//   state = const AsyncValue.loading();
//   state = await AsyncValue.guard(
//       () => _fetchDetails(identifier: identifier, type: type, timeRange: timeRange));
// }
}
