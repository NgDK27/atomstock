import 'package:flutter/material.dart';
import 'package:oppenhomies/domain/models/chat/message_model.dart';
import 'package:oppenhomies/widgets/chat/message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final bool isWaitingForResponse;

  const MessageList({
    super.key,
    required this.messages,
    required this.isWaitingForResponse,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (index < messages.length) {
            return MessageBubble(message: messages[index]);
          } else if (isWaitingForResponse) {
            return const ThinkingMessageBubble();
          }
          return null;
        },
        childCount: messages.length + (isWaitingForResponse ? 1 : 0),
      ),
    );
  }
}