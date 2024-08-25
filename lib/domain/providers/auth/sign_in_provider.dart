import 'package:dio/dio.dart';
import 'package:oppenhomies/domain/helpers/extract_server_response.dart';
import 'package:oppenhomies/domain/models/status/ui_state.dart';
import 'package:oppenhomies/domain/providers/auth/auth_provider.dart';
import 'package:oppenhomies/domain/providers/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_provider.g.dart';

@riverpod
class SignIn extends _$SignIn {
  late final AuthRepository _repository;

  @override
  UiState build() {
    _repository = ref.read(authRepositoryProvider);
    return UiState();
  }

  Future<UiState> signIn(
      {required String email, required String password}) async {
    try {
      final authTokenResponse =
          await _repository.signIn(email: email, password: password);
      await _repository.saveTokens(authTokenResponse);
      ref.read(authProvider.notifier).notifySignedIn();
      return UiState.success();
    } on DioException catch (e) {
      final errorMessage =
          e.response != null && e.response?.data is Map<String, dynamic>
              ? extractErrorResponse(e.response!.data, "NotAuthorizedException")
              : 'Network error occurred';
      state = UiState.failed(message: errorMessage);
      return state;
    } catch (e) {
      state = UiState.failed(message: "An unknown error occurred");
      return state;
    }
  }
}
