import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oppenhomies/domain/models/auth/auth_token_response.dart';
import 'package:oppenhomies/domain/models/state/status.dart';
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
    try {
      final response = await _dio.post(
        '$_apiEndpoint/signin',
        data: {
          "email": email,
          "password": password,
        },
      );

      final authTokenResponse = AuthTokenResponse.fromJson(response.data);
      print(authTokenResponse);
    } catch (e) {
      print(e);
    }
  }
}
