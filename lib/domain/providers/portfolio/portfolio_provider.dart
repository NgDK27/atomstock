import 'dart:developer';

import 'package:oppenhomies/domain/models/stock/portfolio/portfolio.dart';
import 'package:oppenhomies/domain/providers/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'portfolio_provider.g.dart';

@riverpod
class Portfolio extends _$Portfolio {
  late final AuthRepository _repository;

  @override
  Future<PortfolioModel?> build() async {
    _repository = ref.read(authRepositoryProvider);
    return _getPortfolio();
  }

  Future<PortfolioModel?> _getPortfolio() async {
    final PortfolioModel? portfolio = await _repository.fetchPortfolio();
    return portfolio;
  }

  Future<bool> deposit(double amount) async {
    final res = await _repository.deposit(amount);
    refresh();
    return res;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_getPortfolio);
  }
}
