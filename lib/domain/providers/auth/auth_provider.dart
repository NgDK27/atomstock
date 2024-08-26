import 'package:oppenhomies/domain/providers/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthRepository _repository;

  @override
  Future<bool> build() async {
    _repository = ref.read(authRepositoryProvider);
    return _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    return await _repository.hasValidToken();
  }

  Future<bool> notifySignedIn() async {
    return await _repository.hasValidToken();
  }

  Future<void> signOut() async {
    await _repository.clearTokens();
  }
}
