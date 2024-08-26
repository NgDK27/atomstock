import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:oppenhomies/domain/models/stock/exchange_model.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_indexes_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_point.dart';
import 'package:oppenhomies/domain/models/stock/stock_price_points.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_repository.g.dart';

class StockRepository {
  final Dio _dio;
  final String _apiEndpoint;


  StockRepository({
    required Dio dio,
    required String apiEndpoint,
  })  : _dio = dio,
        _apiEndpoint = apiEndpoint;

  Future<StockMarketModel> fetchStockMarketOverview() async {
    final response = await _dio.get('$_apiEndpoint:8080/main-market');
    return StockMarketModel.fromJson(response.data);
  }

  Future<StockMarketIndexesModel> fetchStockMarketIndexes() async {
    final response = await _dio.get('$_apiEndpoint:8080/main-market?category=indexes');
    return StockMarketIndexesModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopVolume() async {
    final response = await _dio.get('$_apiEndpoint:8080/main-market?category=volume');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopIncrease() async {
    final response = await _dio.get('$_apiEndpoint:8080/main-market?category=increase');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopDecrease() async {
    final response = await _dio.get('$_apiEndpoint:8080/main-market?category=decrease');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockModel> fetchStockDetails({required String symbol}) async {
    try {
      final responses = await Future.wait([
        _dio.get('$_apiEndpoint:8080/stock/$symbol'),
        _dio.get('$_apiEndpoint:8000/ticker/$symbol'),
      ]);

      final stockData = responses[0].data;
      final tickerData = responses[1].data;

      final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

      final List<StockPricePoint> pricePoints = (tickerData['historical_data'] as List)
          .map((point) => StockPricePoint(
        timestamp: dateFormat.parse('${point['TradingDate']} ${point['Time']}'),
        price: double.parse(point['ClosePrice']),
      ))
          .toList();

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

  Future<IndexModel> fetchIndexDetails({required String id}) async {
    final response = await _dio.get('$_apiEndpoint:8080/index/$id');
    return IndexModel.fromJson(response.data);
  }
}

@riverpod
StockRepository stockRepository(StockRepositoryRef ref) {
  return StockRepository(
    dio: Dio(),
    apiEndpoint: 'http://192.168.25.229',
  );
}