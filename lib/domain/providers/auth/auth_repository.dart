import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oppenhomies/domain/models/auth/auth_token_response.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final String _apiEndpoint;

  AuthRepository({
    required Dio dio,
    required FlutterSecureStorage storage,
    required String apiEndpoint,
  })  : _dio = dio,
        _storage = storage,
        _apiEndpoint = apiEndpoint;

  Future<AuthTokenResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '$_apiEndpoint/signin',
      data: {"email": email, "password": password},
    );
    return AuthTokenResponse.fromJson(response.data);
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _dio.post(
      '$_apiEndpoint/signup',
      data: {"email": email, "password": password},
    );
  }

  Future<void> saveTokens(AuthTokenResponse tokens) async {
    await _storage.write(key: 'access_token', value: tokens.accessToken);
    await _storage.write(key: 'id_token', value: tokens.idToken);
    await _storage.write(key: 'refresh_token', value: tokens.refreshToken);
  }

  Future<bool> hasValidToken() async {
    final accessToken = await _storage.read(key: 'access_token');
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}