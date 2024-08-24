import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oppenhomies/domain/helpers/extract_server_response.dart';
import 'package:oppenhomies/domain/models/auth/auth_state.dart';
import 'package:oppenhomies/domain/models/status/ui_state.dart';
import 'package:oppenhomies/domain/providers/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = AuthRepository(
      dio: Dio(),
      storage: const FlutterSecureStorage(),
      apiEndpoint: 'http://192.168.25.229:2708',
    );
    return const AuthState();
  }

  Future<UiState> signIn({required String email, required String password}) async {
    try {
      final authTokenResponse = await _repository.signIn(email: email, password: password);
      await _repository.saveTokens(authTokenResponse);

      state = state.copyWith(
        isAuthenticated: true,
        accessToken: authTokenResponse.accessToken,
        idToken: authTokenResponse.idToken,
        refreshToken: authTokenResponse.refreshToken,
        email: email,
      );
      return UiState.success();
    } on DioException catch (e) {
      final errorMessage = e.response != null && e.response?.data is Map<String, dynamic>
          ? extractErrorResponse(e.response!.data, "NotAuthorizedException")
          : 'Network error occurred';
      return UiState.failed(message: errorMessage);
    } catch (e) {
      return UiState.failed(message: "An unknown error happened");
    }
  }

  Future<UiState> signUp({required String email, required String password}) async {
    try {
      await _repository.signUp(email: email, password: password);
      state = state.copyWith(email: email);
      return UiState.success();
    } on DioException catch (e) {
      final errorMessage = e.response != null && e.response?.data is Map<String, dynamic>
          ? extractUserFriendlyErrorMessage(e.response!.data)
          : 'Network error occurred';
      return UiState.failed(message: errorMessage);
    } catch (e) {
      return UiState.failed(message: "An unknown error happened");
    }
  }

  Future<bool> isSignedIn() async {
    final hasValidToken = await _repository.hasValidToken();
    state = state.copyWith(isAuthenticated: hasValidToken);
    return hasValidToken;
  }

  Future<UiState> signOut() async {
    try {
      await _repository.clearTokens();
      state = const AuthState();
      return UiState.success();
    } catch (e) {
      return UiState.failed();
    }
  }
}