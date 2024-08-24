import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oppenhomies/domain/helpers/extract_server_response.dart';
import 'package:oppenhomies/domain/models/auth/auth_token_response.dart';
import 'package:oppenhomies/domain/models/state/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as dev;

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String _apiEndpoint = 'http://192.168.25.229:2708';

  @override
  State build() => State.initialized();

  Future<void> signIn({required String email, required String password}) async {
    state = State.loading();

    try {
      final response = await _dio.post(
        '$_apiEndpoint/signin',
        data: {
          "email": email,
          "password": password,
        },
      );

      dev.log('Response: ${response.toString()}');
      final authTokenResponse = AuthTokenResponse.fromJson(response.data);
      state = State.success();
    } on DioException catch (e) {
      if (e.response != null) {
        dev.log('Error Response: ${e.response?.data}');

        String errorMessage = 'An error occurred';
        if (e.response?.data is Map<String, dynamic>) {
          errorMessage = extractErrorResponse(e.response!.data, 'NotAuthorizedException');
        }

        state = State.failed(message: errorMessage);
      } else {
        state = State.failed(message: 'Network error occurred');
      }
    } catch (e) {
      dev.log('Unexpected error: ${e.toString()}');
      state = State.failed(message: 'An unexpected error occurred');
    }
  }
}