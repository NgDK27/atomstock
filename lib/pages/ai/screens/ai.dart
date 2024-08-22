import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/domain/services/services.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';

class Ai extends HookConsumerWidget {
  const Ai({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openAIService = useState(OpenAIService());
    final controller = useTextEditingController();
    final messages = useState<List<Map<String, String>>>([
      {'sender': 'bot', 'text': 'Hello! How can I assist you today?'},
      {'sender': 'user', 'text': 'I have a question about Flutter.'},
      {
        'sender': 'bot',
        'text':
            'Great! I\'d be happy to help you with Flutter. What specific question do you have?'
      },
      {'sender': 'user', 'text': 'How do I use hooks in Flutter?'},
      {
        'sender': 'bot',
        'text':
            'Hooks in Flutter, specifically with the flutter_hooks package, allow you to use state and other React-like features in functional components. Here\'s a basic example:\n\n1. First, make sure you have flutter_hooks in your pubspec.yaml.\n2. Import the package: import \'package:flutter_hooks/flutter_hooks.dart\';\n3. Create a HookWidget instead of a StatelessWidget.\n4. Use hooks like useState inside your build method.\n\nFor example:\n\nclass Counter extends HookWidget {\n  @override\n  Widget build(BuildContext context) {\n    final count = useState(0);\n    return Text(\'\${count.value}\');\n  }\n}\n\nThis creates a simple counter state. Hooks make managing state in widgets much simpler!'
      },
    ]);
    final hasStartedChat = useState(true);
    final isLoggedIn = useState(true); // Simulating user login status

    void sendMessage() async {
      final text = controller.text;
      if (text.isNotEmpty) {
        hasStartedChat.value = true;
        messages.value = [
          ...messages.value,
          {'sender': 'user', 'text': text}
        ];
        controller.clear();

        final response =
            await openAIService.value.generateResponse(text, 'user-123');
        messages.value = [
          ...messages.value,
          {'sender': 'bot', 'text': response.trim()}
        ];
      }
    }

    void startNewConversation() {
      messages.value = [];
      hasStartedChat.value = false;
    }

    Widget buildDrawer() {
      return Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the drawer
                    },
                    child: Icon(Icons.close),
                  ),
                  GestureDetector(
                    onTap: () {
                      startNewConversation();
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: Text('Example Conversation 1'),
                    onTap: () {
                      Navigator.pop(context);
                      // Load conversation 1
                    },
                  ),
                  ListTile(
                    title: Text('Example Conversation 2'),
                    onTap: () {
                      Navigator.pop(context);
                      // Load conversation 2
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget buildFAQItem(String question) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          question,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    Widget buildWelcomeScreen() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // buildFAQItem("What can this chatbot do?"),
            // buildFAQItem("How can I improve my skills?"),
            // buildFAQItem("What are the current trends?"),
            // buildFAQItem("How can I contact support?"),
            // buildFAQItem("Where can I find more information?"),
          ],
        ),
      );
    }

    Widget buildMessageItem(Map<String, String> message) {
      return Align(
        alignment: message['sender'] == 'user'
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: OpSpacing.md,vertical: OpSpacing.xs2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(OpRadius.xl)),
            color:
            message['sender'] == 'user' ? OpDynamicColor.primaryVariant(context) : OpDynamicColor.surfaceContainerHigh(context).withOpacity(OpOpacity.secondary),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['text'] ?? '', style: OpTextStyle.body(context)?.copyWith(
                  color: message['sender'] == 'user' ? OpDynamicColor.onSurface(context) : OpDynamicColor.onSurface(context),
                ),),
              ],
            ),
          ),
        ),
      );
    }

    return OpPlatformSliverScaffold(
      title: "AI Advisor",
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        if (hasStartedChat.value && messages.value.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => buildMessageItem(messages.value[index]),
              childCount: messages.value.length,
            ),
          )
        else
          SliverToBoxAdapter(child: buildWelcomeScreen()),
      ],
      floatingBottomWidget: BottomBar(
        child: Row(
          children: [
            Expanded(
              child: PlatformTextField(
                controller: controller,
                hintText: "Ask the Advisor about...",
                autocorrect: true,
                autofocus: true,
              ),
            ),
            IconButton(
              icon: Icon(PlatformIcons(context).upArrow),
              onPressed: sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
