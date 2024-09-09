import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;
import 'package:oppenhomies/domain/models/auth/auth_token_response.dart';
import 'package:oppenhomies/domain/models/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final dio.Dio _dio;
  final secure_storage.FlutterSecureStorage _storage;
  final String _apiEndpoint;

  AuthRepository({
    required dio.Dio dio,
    required secure_storage.FlutterSecureStorage storage,
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

  Future<void> verifySignUp({
    required String email,
    required String otp,
  }) async {
    await _dio.post(
      '$_apiEndpoint/confirm_signup',
      data: {"email": email, "otp": otp},
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

    // return true;
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  Future<UserModel?> getUserInfo() async {
    if (await hasValidToken()) {
      final String? accessToken = await _storage.read(key: 'access_token');

      final response = await _dio.get('$_apiEndpoint/user',
          options:
              dio.Options(headers: {'authorization': 'Bearer $accessToken'}));

      final user = UserModel.fromJson(response.data);
      log(user.toString());

      return UserModel.fromJson(response.data);
    }

    return null;
  }

  Future<bool> deposit(double amount) async {
    if (await hasValidToken()) {
      final String? accessToken = await _storage.read(key: 'access_token');
log(amount.toString());
      log('$amount');

      final response = await _dio.post(
        '$_apiEndpoint/deposit',
        options: dio.Options(headers: {'authorization': 'Bearer $accessToken'}),
        data: {
          'amount': '$amount',
        },
      );

      log(response.toString());

      if (response.data['message'] == 'Balance updated successfully') {
        return true;
      }
    }

    return false;
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    dio: dio.Dio(),
    storage: const secure_storage.FlutterSecureStorage(),
    apiEndpoint: 'http://192.168.25.122:8080',
  );
}
