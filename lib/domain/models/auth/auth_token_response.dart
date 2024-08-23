import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token_response.freezed.dart';

part 'auth_token_response.g.dart';

@freezed
class AuthTokenResponse with _$AuthTokenResponse {
  factory AuthTokenResponse({
    @JsonKey(name: 'access_token') required String? accessToken,
    @JsonKey(name: 'id_token')required String? idToken,
    @JsonKey(name: 'refresh_token')required String? refreshToken,
    required String? message,
  }) = _AuthTokenResponse;

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResponseFromJson(json);
}
