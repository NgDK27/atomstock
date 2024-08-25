
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/helpers/extract_server_response.dart';
import 'package:oppenhomies/domain/models/status/ui_state.dart';
import 'package:oppenhomies/domain/providers/auth/auth_repository.dart';
import 'package:oppenhomies/domain/providers/auth/sign_in_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_provider.freezed.dart';
part 'sign_up_provider.g.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default(UiState()) UiState uiState,
    String? tempEmail,
    String? tempPassword,
  }) = _SignUpState;
}

@Riverpod(keepAlive: true)
@riverpod
class SignUp extends _$SignUp {
  late final AuthRepository _repository;

  @override
  SignUpState build() {
    _repository = ref.read(authRepositoryProvider);
    return const SignUpState();
  }

  void setTempEmail(String email) {
    state = state.copyWith(tempEmail: email);
  }

  void setTempPassword(String password) {
    state = state.copyWith(tempPassword: password);
  }

  Future<SignUpState> signUp(
      {required String tempEmail, required String tempPassword}) async {
    try {
      await _repository.signUp(email: tempEmail, password: tempPassword);
      state = state.copyWith(
          uiState: UiState.success(),
          tempEmail: tempEmail,
          tempPassword: tempPassword);
      return state;
    } on DioException catch (e) {
      final errorMessage =
          e.response != null && e.response?.data is Map<String, dynamic>
              ? extractUserFriendlyErrorMessage(e.response!.data)
              : 'Network error occurred';
      state = state.copyWith(uiState: UiState.failed(message: errorMessage));
      return state;
    } catch (e) {
      state = state.copyWith(
          uiState: UiState.failed(message: "An unknown error occurred"));
      return state;
    }
  }

  Future<void> clearTemps() async {
    state = state.copyWith(tempPassword: null, tempEmail: null);
  }

  Future<SignUpState> verifySignUp({
    required String otp,
  }) async {
    try {
      await _repository.verifySignUp(email: state.tempEmail!, otp: otp);

      final signInNotifier  = ref.read(signInProvider.notifier);
      final result = await signInNotifier.signIn(email: state.tempEmail!, password: state.tempPassword!);

      if (result == UiState.success()) {
        state = state.copyWith(uiState: UiState.success());
        await clearTemps();
        return state;
      } else {
        state = state.copyWith(uiState: UiState.failed(message: result.message));
        return state;
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response != null && e.response?.data is Map<String, dynamic>
              ? extractUserFriendlyErrorMessage(e.response!.data)
              : 'Network error occurred';
      state = state.copyWith(uiState: UiState.failed(message: errorMessage));
      return state;
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.failed(message: "An unknown error occurred"),
      );
      return state;
    }
  }
}
