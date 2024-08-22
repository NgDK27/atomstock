import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oppenhomies/domain/models/chat/message_model.dart';
import 'package:oppenhomies/domain/models/chat/sender_enum.dart';
import 'package:oppenhomies/domain/services/services.dart';

UseChat useChat(ScrollController scrollController) {
  final openAIService = useState(OpenAIService());
  final messages = useState<List<MessageModel>>([]);
  final hasStartedChat = useState(false);
  final isWaitingForResponse = useState(false);

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final sendMessage = useCallback((String text) async {
    if (text.isNotEmpty) {
      hasStartedChat.value = true;
      messages.value = [...messages.value, MessageModel(message: text, sender: Sender.user)];
      scrollToBottom();
      isWaitingForResponse.value = true;

      final response = await openAIService.value.generateResponse(text, 'user-123');

      isWaitingForResponse.value = false;
      messages.value = [...messages.value, MessageModel(message: response.trim(), sender: Sender.bot)];
      scrollToBottom();
    }
  }, [messages, hasStartedChat, openAIService, isWaitingForResponse, scrollController]);

  final startNewConversation = useCallback(() {
    messages.value = [];
    hasStartedChat.value = false;
  }, [messages, hasStartedChat]);

  return (
  messages: messages.value,
  hasStartedChat: hasStartedChat.value,
  isWaitingForResponse: isWaitingForResponse.value,
  sendMessage: sendMessage,
  startNewConversation: startNewConversation,
  );
}

typedef UseChat = ({
List<MessageModel> messages,
bool hasStartedChat,
bool isWaitingForResponse,
void Function(String) sendMessage,
void Function() startNewConversation,
});