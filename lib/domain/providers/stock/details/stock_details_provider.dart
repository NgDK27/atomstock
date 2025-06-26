import 'dart:async';
import 'package:oppenhomies/domain/models/stock/stock_item_type.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_date_filters.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_point.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_points.dart';
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
  StockPriceDateFilter _currentTimeRange = StockPriceDateFilter.oneDay;

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

    // Only listen to real-time updates when in 1D view
    if (_currentTimeRange != StockPriceDateFilter.oneDay) {
      return;
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

    // Update price points only for 1D view
    StockPricePoints? updatedPricePoints;
    if (_currentTimeRange == StockPriceDateFilter.oneDay && currentModel.pricePoints != null) {
      final newPoint = StockPricePoint(
        timestamp: DateTime.now(),
        price: update.currentPrice,
      );

      final currentPoints = List<StockPricePoint>.from(currentModel.pricePoints!.points);
      currentPoints.add(newPoint);

      updatedPricePoints = StockPricePoints(points: currentPoints);
    }

    return currentModel.copyWith(
      currentPrice: update.currentPrice,
      priceChange: update.priceChange,
      percentChange: update.percentChange,
      totalVolume: update.volume,
      change: change,
      pricePoints: updatedPricePoints ?? currentModel.pricePoints,
    );
  }

  StockModel _updateIndexData(StockModel currentModel, IndexDetailUpdate update) {
    StockChange? change;
    if (update.indexValue > currentModel.currentPrice) {
      change = StockChange.increase;
    } else if (update.indexValue < currentModel.currentPrice) {
      change = StockChange.decrease;
    }

    // Update price points only for 1D view
    StockPricePoints? updatedPricePoints;
    if (_currentTimeRange == StockPriceDateFilter.oneDay && currentModel.pricePoints != null) {
      final newPoint = StockPricePoint(
        timestamp: DateTime.now(),
        price: update.indexValue,
      );

      final currentPoints = List<StockPricePoint>.from(currentModel.pricePoints!.points);
      currentPoints.add(newPoint);

      updatedPricePoints = StockPricePoints(points: currentPoints);
    }

    return currentModel.copyWith(
      currentPrice: update.indexValue,
      priceChange: update.change,
      percentChange: update.percentChange,
      totalVolume: update.totalQtty?.toDouble() ?? currentModel.totalVolume,
      totalValue: update.totalValue,
      change: change,
      pricePoints: updatedPricePoints ?? currentModel.pricePoints,
    );
  }

  Future<StockModel> _fetchDetails({
    required String identifier,
    required StockItemType type,
    required StockPriceDateFilter timeRange,
  }) async {
    _currentTimeRange = timeRange;
    final now = DateTime.now();

    final result = switch (type) {
      StockItemType.idx => await _repository.fetchIndexDetails(id: identifier, timeRange: timeRange.serverParameter),
      StockItemType.stock => await _repository.fetchStockDetails(symbol: identifier, timeRange: timeRange.serverParameter),
    };

    // Filter out future price points (mock data issue)
    if (result.pricePoints != null) {
      final pastPoints = result.pricePoints!.points
          .where((point) => point.timestamp.isBefore(now) || point.timestamp.isAtSameMomentAs(now))
          .toList();

      return result.copyWith(
        pricePoints: StockPricePoints(points: pastPoints),
      );
    }

    return result;
  }

  Future<void> updateDetailsWithTimeRange({required StockPriceDateFilter timeRange}) async {
    _currentTimeRange = timeRange;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchDetails(
      identifier: identifier,
      type: type,
      timeRange: timeRange,
    ),);
    _listenToUpdates(state.value!, identifier, type);
  }

  Future<void> refreshStockDetails(
      String identifier, StockItemType type, StockPriceDateFilter timeRange) async {
    _currentTimeRange = timeRange;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
            () => _fetchDetails(identifier: identifier, type: type, timeRange: timeRange));
  }
}