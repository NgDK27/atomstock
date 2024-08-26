import 'package:dio/dio.dart';
import 'package:oppenhomies/domain/models/stock/index_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_indexes_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_model.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/models/stock/stock_model.dart';
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
    final response = await _dio.get('$_apiEndpoint/main-market');
    return StockMarketModel.fromJson(response.data);
  }

  Future<StockMarketIndexesModel> fetchStockMarketIndexes() async {
    final response = await _dio.get('$_apiEndpoint/main-market?category=indexes');
    return StockMarketIndexesModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopVolume() async {
    final response = await _dio.get('$_apiEndpoint/main-market?category=volume');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopIncrease() async {
    final response = await _dio.get('$_apiEndpoint/main-market?category=increase');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockMarketStocksModel> fetchStockMarketTopDecrease() async {
    final response = await _dio.get('$_apiEndpoint/main-market?category=decrease');
    return StockMarketStocksModel.fromJson(response.data);
  }

  Future<StockModel> fetchStockDetails({required String symbol}) async {
    final response = await _dio.get('$_apiEndpoint/stock/$symbol');
    return StockModel.fromJson(response.data);
  }

  Future<IndexModel> fetchIndexDetails({required String id}) async {
    final response = await _dio.get('$_apiEndpoint/index/$id');
    return IndexModel.fromJson(response.data);
  }
}

@riverpod
StockRepository stockRepository(StockRepositoryRef ref) {
  return StockRepository(
    dio: Dio(),
    apiEndpoint: 'http://192.168.25.229:8080',
  );
}