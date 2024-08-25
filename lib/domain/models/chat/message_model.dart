import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oppenhomies/domain/models/chat/sender_enum.dart';

part 'message_model.freezed.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String? message,
    required Sender sender,
  }) = _MessageModel;
}
