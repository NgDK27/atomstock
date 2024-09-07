// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthTokenResponseImpl _$$AuthTokenResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthTokenResponseImpl(
      accessToken: json['access_token'] as String?,
      idToken: json['id_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$AuthTokenResponseImplToJson(
        _$AuthTokenResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'id_token': instance.idToken,
      'refresh_token': instance.refreshToken,
      'message': instance.message,
    };
