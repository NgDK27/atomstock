import 'package:dio/dio.dart';
import 'package:oppenhomies/domain/models/stock/stock_market_model.dart';
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
}

@riverpod
StockRepository stockRepository(StockRepositoryRef ref) {
  return StockRepository(
    dio: Dio(),
    apiEndpoint: 'http://192.168.25.229:8080',
  );
}