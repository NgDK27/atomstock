import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'status.freezed.dart';

@freezed
class Status with _$Status {
  const factory Status.initialized() = _Initialized;
  const factory Status.loading() = _Loading;
  const factory Status.success() = _Success;
  const factory Status.error(String message) = _Error;
  const factory Status.awaitingUpdate() = _AwaitingUpdate;
}