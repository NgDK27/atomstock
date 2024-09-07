import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/domain/models/chat/message_model.dart';
import 'package:oppenhomies/domain/models/chat/sender_enum.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';

class BaseMessageBubble extends ConsumerWidget {
  final String message;
  final String? senderName;

  const BaseMessageBubble({
    super.key,
    required this.message,
    this.senderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: OpSpacing.xs,
          vertical: OpSpacing.xs2,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(OpRadius.md)),
          color: bubbleColor(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: OpSpacing.xs, vertical: OpSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (senderName != null)
                Column(
                  children: [
                    Text(
                      senderName!,
                      style: OpTextStyle.labelSmall(context)
                          .bold()
                          .spacedOut()
                          .copyWith(
                            color: senderNameColor(context),
                          ),
                    ),
                    SizedBox(
                      height: platformThemeData(
                        context,
                        material: (_) => OpSpacing.xs3,
                        cupertino: (_) => OpSpacing.xs,
                      ),
                    ),
                  ],
                ),
              MarkdownBody(
                data: message,
                styleSheet: MarkdownStyleSheet(
                  p: messageTextStyle(context)?.copyWith(
                    color: messageTextColor(context),),
                  listBullet:messageTextStyle(context)?.copyWith(
                      color: messageTextColor(context),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color bubbleColor(BuildContext context) => OpDynamicColor.surface(context);

  Color senderNameColor(BuildContext context) =>
      OpDynamicColor.onSurfaceVariant(context);

  Color messageTextColor(BuildContext context) =>
      OpDynamicColor.onSurface(context);

  TextStyle? messageTextStyle(BuildContext context) => OpTextStyle.body(context);
}

class UserMessageBubble extends BaseMessageBubble {
  const UserMessageBubble({
    super.key,
    required super.message,
  }) : super(senderName: "You");

  @override
  Color bubbleColor(BuildContext context) =>
      OpDynamicColor.surfaceContainer(context);
}

class BotMessageBubble extends BaseMessageBubble {
  const BotMessageBubble({
    super.key,
    required super.message,
  });

  @override
  TextStyle? messageTextStyle(BuildContext context) {
    return OpTextStyle.bodyLarge(context)?.copyWith(
      height: 1.6,
    );
  }
}

class ThinkingMessageBubble extends BaseMessageBubble {
  const ThinkingMessageBubble({
    super.key,
  }) : super(message: "Thinking...");

  @override
  Color messageTextColor(BuildContext context) {
    return OpDynamicColor.onSurfaceVariant(context).withOpacity(OpOpacity.secondary);
  }
}

class MessageBubble extends ConsumerWidget {
  final MessageModel message;
  final bool isThinking;

  const MessageBubble({
    super.key,
    required this.message,
    this.isThinking = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isThinking) {
      return const ThinkingMessageBubble();
    }

    switch (message.sender) {
      case Sender.user:
        return UserMessageBubble(message: message.message ?? '');
      case Sender.bot:
        return BotMessageBubble(message: message.message ?? '');
    }
  }
}