import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oppenhomies/domain/helpers/extract_server_response.dart';
import 'package:oppenhomies/domain/models/auth/auth_token_response.dart';
import 'package:oppenhomies/domain/models/status/status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String _apiEndpoint = 'http://192.168.25.229:2708';

  @override
  Status build() => Status.initialized();

  Future<void> signIn({required String email, required String password}) async {
    state = Status.loading();

    try {
      final response = await _dio.post(
        '$_apiEndpoint/signin',
        data: {
          "email": email,
          "password": password,
        },
      );

      final authTokenResponse = AuthTokenResponse.fromJson(response.data);

      // Save tokens to secure storage
      await _saveTokens(authTokenResponse);

      state = Status.success();
    } on DioException catch (e) {
      if (e.response != null) {

        String errorMessage = 'An error occurred';
        if (e.response?.data is Map<String, dynamic>) {
          errorMessage = extractErrorResponse(e.response!.data, 'NotAuthorizedException');
        }

        state = Status.failed(message: errorMessage);
      } else {
        state = Status.failed(message: 'Network error occurred');
      }
    } catch (e) {
      state = Status.failed(message: 'An unexpected error occurred');
    }
  }

  Future<void> _saveTokens(AuthTokenResponse tokens) async {
    await _storage.write(key: 'access_token', value: tokens.accessToken);
    await _storage.write(key: 'id_token', value: tokens.idToken);
    await _storage.write(key: 'refresh_token', value: tokens.refreshToken);
  }

  Future<bool> isSignedIn() async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      // dev.log('Error checking sign-in status: ${e.toString()}');
      return false;
    }
  }

  Future<void> signOut() async {
    state = Status.initialized();
    try {
      await _storage.deleteAll();
      state = Status.success();
    } catch (e) {
      state = Status.failed(message: 'Failed to sign out: ${e.toString()}');
    }
  }
}