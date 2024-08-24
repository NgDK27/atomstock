import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/status/ui_state.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    String? accessToken,
    String? idToken,
    String? refreshToken,
    String? email,
  }) = _AuthState;
}