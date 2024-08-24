import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'states.dart';

part 'state.freezed.dart';

@freezed
class State with _$State {
  const factory State({
    @Default(States.initialized) final States state,
    final String? message,
  }) = _State;

  factory State.initialized() => const State(state: States.initialized);

  factory State.loading() => const State(state: States.loading);

  factory State.success() => const State(state: States.success);

  factory State.failed({String? message}) => State(
    state: States.failed,
    message: message,
  );

  factory State.awaitingUpdate() => const State(state: States.awaitingUpdate);
}