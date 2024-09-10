import 'package:oppenhomies/domain/helpers/search_query_formatter.dart';
import 'package:oppenhomies/domain/models/stock/market_list/stock_market_stocks_model.dart';
import 'package:oppenhomies/domain/providers/stock/repository/stock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_search.g.dart';

@Riverpod(keepAlive: true)
@riverpod
class StockSearch extends _$StockSearch {
  late final StockRepository _repository;

  @override
  Future<StockMarketStocksModel?> build() async {
    _repository = ref.read(stockRepositoryProvider);
    return StockMarketStocksModel(stocks: []);
  }

  Future<void> searchStock(String query) async {
    String formattedQuery = SearchQueryFormatter.format(query);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.searchStock(formattedQuery);
    });
  }
}
