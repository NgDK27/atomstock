import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'statuses.dart';

part 'status.freezed.dart';

@freezed
class Status with _$Status {
  const factory Status({
    @Default(Statuses.initialized) final Statuses status,
    final String? message,
  }) = _Status;

  factory Status.initialized() => const Status(status: Statuses.initialized);

  factory Status.loading() => const Status(status: Statuses.loading);

  factory Status.success() => const Status(status: Statuses.success);

  factory Status.failed({String? message}) => Status(
    status: Statuses.failed,
    message: message,
  );

  factory Status.awaitingUpdate() => const Status(status: Statuses.awaitingUpdate);
}