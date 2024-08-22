import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/pages/ai/layouts/chat_input.dart';
import 'package:oppenhomies/pages/ai/layouts/chat_welcome_screen.dart';
import 'package:oppenhomies/pages/ai/layouts/message_list.dart';
import 'package:oppenhomies/pages/ai/layouts/new_chat_button.dart';
import 'package:oppenhomies/pages/ai/models/chat_hooks.dart';
import 'package:oppenhomies/pages/ai/models/chat_auto_scroll.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';


class Ai extends HookConsumerWidget {
  const Ai({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final chatState = useChat(scrollController);

    useChatAutoScroll(scrollController);

    return OpPlatformSliverScaffold(
      title: "AI Advisor",
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollController: scrollController,
      topBarTrailing: chatState.hasStartedChat
          ? NewChatButton(onPressed: chatState.startNewConversation)
          : null,
      slivers: [
        if (chatState.hasStartedChat && chatState.messages.isNotEmpty)
          MessageList(
            messages: chatState.messages,
            isWaitingForResponse: chatState.isWaitingForResponse,
          )
        else
          const SliverToBoxAdapter(child: ChatWelcomeScreen()),
      ],
      floatingBottomWidget: ChatInput(
        onSend: chatState.sendMessage,
        isWaitingForResponse: chatState.isWaitingForResponse,
      ),
    );
  }
}

// Widget buildDrawer() {
//   return Drawer(
//     child: Column(
//       children: <Widget>[
//         SizedBox(height: 50.0),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Close the drawer
//                 },
//                 child: Icon(Icons.close),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   startNewConversation();
//                   Navigator.pop(context);
//                 },
//                 child: Image.asset(
//                   'assets/images/app_icon.png',
//                   height: 30,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: <Widget>[
//               ListTile(
//                 title: Text('Example Conversation 1'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Load conversation 1
//                 },
//               ),
//               ListTile(
//                 title: Text('Example Conversation 2'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Load conversation 2
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
