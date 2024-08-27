import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:oppenhomies/domain/helpers/index_model_converter.dart';
import 'package:oppenhomies/domain/helpers/market_hours_service.dart';
import 'package:oppenhomies/domain/models/stock/exchange_model.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_indexes_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_point.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_points.dart';
import 'package:oppenhomies/domain/models/stock/stock_update.dart';
import 'package:oppenhomies/domain/models/ws/websocket.dart';
import 'package:oppenhomies/domain/providers/websocket_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_repository.g.dart';

class StockRepository {
  final Dio _dio;
  final String _apiEndpoint;
  final WebSocketManager _wsManager;

  StockRepository({
    required Dio dio,
    required String apiEndpoint,
    required WebSocketManager wsManager,
  })  : _dio = dio,
        _apiEndpoint = apiEndpoint,
        _wsManager = wsManager;

  Future<StockMarketModel> fetchStockMarketOverview() async {
    final response = await _dio.get('$_apiEndpoint:8080/main-market');
    return StockMarketModel.fromJson(response.data);
  }

  Stream<StockUpdate> getStockUpdates() {
    if (MarketHoursService.isMarketOpen()) {
      print("bruh");
      return _wsManager
          .connect('/ws/main-market')
          .map((event) => StockUpdate.fromJson(jsonDecode(event)));
    } else {
      print("nobruh");
      return const Stream.empty();
    }
  }

  Future<StockMarketIndexesModel> fetchStockMarketIndexes() async {
    final response =
        await _dio.get('$_apiEndpoint:8080/main-market?category=indexes');
    return StockMarketIndexesModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopVolume() async {
    final response =
        await _dio.get('$_apiEndpoint:8080/main-market?category=volume');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopIncrease() async {
    final response =
        await _dio.get('$_apiEndpoint:8080/main-market?category=increase');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopDecrease() async {
    final response =
        await _dio.get('$_apiEndpoint:8080/main-market?category=decrease');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockModel> fetchStockDetails(
      {required String symbol, String? timeRange}) async {
    try {
      final stockFuture = _dio.get('$_apiEndpoint:8080/stock/$symbol');
      final tickerFuture = timeRange != null
          ? _dio.get('$_apiEndpoint:8000/ticker/$symbol?range=$timeRange')
          : _dio.get('$_apiEndpoint:8000/ticker/$symbol');

      final responses = await Future.wait([stockFuture, tickerFuture]);

      final stockData = responses[0].data;
      final tickerData = responses[1].data;

      final dateFormat = DateFormat('dd/MM/yyyy');
      final dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

      final List<StockPricePoint> pricePoints =
          (tickerData['historical_data'] as List).map((point) {
        final date = dateFormat.parse(point['TradingDate']);
        final time = point['Time'];
        final timestamp = time != null
            ? dateTimeFormat.parse('${point['TradingDate']} $time')
            : DateTime(date.year, date.month, date.day);

        return StockPricePoint(
          timestamp: timestamp,
          price: double.parse(point['ClosePrice']),
        );
      }).toList();

      return StockModel(
        name: tickerData['name'],
        symbol: stockData['Symbol'],
        currentPrice: stockData['Price'],
        priceChange: stockData['Change'],
        percentChange: stockData['RatioChange'],
        totalVolume: stockData['Volume'],
        exchange: ExchangeModel(
          symbol: tickerData['market'],
        ),
        pricePoints: StockPricePoints(points: pricePoints),
      );
    } catch (e) {
      // Handle errors
      throw Exception('Failed to fetch stock details: $e');
    }
  }

  Future<StockModel> fetchIndexDetails(
      {required String id, String? timeRange}) async {
    {
      try {
        final stockFuture = _dio.get('$_apiEndpoint:8080/index/$id');
        final tickerFuture = timeRange != null
            ? _dio.get('$_apiEndpoint:8000/ticker/$id?range=$timeRange')
            : _dio.get('$_apiEndpoint:8000/ticker/$id');

        final responses = await Future.wait([stockFuture, tickerFuture]);

        final indexData = responses[0].data;
        final tickerData = responses[1].data;

        final dateFormat = DateFormat('dd/MM/yyyy');
        final dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

        final List<StockPricePoint> pricePoints =
            (tickerData['historical_data'] as List).map((point) {
          final date = dateFormat.parse(point['TradingDate']);
          final time = point['Time'];
          final timestamp = time != null
              ? dateTimeFormat.parse('${point['TradingDate']} $time')
              : DateTime(date.year, date.month, date.day);

          return StockPricePoint(
            timestamp: timestamp,
            price: double.parse(point['ClosePrice']),
          );
        }).toList();

        final index = IndexModel.fromJson(indexData);
        final stockFromIndex = index.toStockModel();

        return stockFromIndex.copyWith(
          exchange: ExchangeModel(
            symbol: tickerData['market'],
          ),
          pricePoints: StockPricePoints(points: pricePoints),
        );
      } catch (e) {
        // Handle errors
        throw Exception('Failed to fetch index details: $e');
      }
    }
  }
}

@riverpod
StockRepository stockRepository(StockRepositoryRef ref) {
  return StockRepository(
    dio: Dio(),
    apiEndpoint: 'http://192.168.25.229',
    wsManager: ref.watch(webSocketManagerProvider),
  );
}
