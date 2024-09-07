import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'ui_states_enum.dart';

part 'ui_state.freezed.dart';

@freezed
class UiState with _$UiState {
  const factory UiState({
    @Default(UiStates.initialized) final UiStates state,
    final String? message,
  }) = _Status;

  factory UiState.initialized() => const UiState(state: UiStates.initialized);

  factory UiState.loading() => const UiState(state: UiStates.loading);

  factory UiState.success() => const UiState(state: UiStates.success);

  factory UiState.failed({String? message}) => UiState(
    state: UiStates.failed,
    message: message,
  );

  factory UiState.awaitingUpdate() => const UiState(state: UiStates.awaitingUpdate);
}