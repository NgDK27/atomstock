import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final _storage = const FlutterSecureStorage();

  @override
  Future<bool> build() async {
    return _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    final accessToken = await _storage.read(key: 'access_token');
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<bool> notifySignedIn() async {
    final accessToken = await _storage.read(key: 'access_token');
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> signOut() async {
    await _storage.deleteAll();
    state = const AsyncValue.data(false);
  }
}