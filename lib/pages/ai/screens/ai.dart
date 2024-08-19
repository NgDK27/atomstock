import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/domain/services/services.dart';
import 'package:flutter/material.dart';


// class Ai extends ConsumerWidget {
//   const Ai({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) =>
//       OpPlatformSliverScaffold(title: "AI",
//           transitionBetweenRoutes: false,
//           slivers: [
//         SliverSafeArea(
//           top: false,
//           sliver: SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (BuildContext context, int index) => const Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [

//                     SizedBox(height: OpSpacing.md),

//                   ],
//               ),
//               childCount: 15,
//             ),
//           ),
//         ),
//       ],);
// }





class Ai extends ConsumerWidget {
  const Ai({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: Text("AI Chatbot"),
        ),
        body: ChatScreen(),
      );
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final OpenAIService openAIService = OpenAIService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool hasStartedChat = false;

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        hasStartedChat = true;
        messages.add({'sender': 'user', 'text': text});
      });
      _controller.clear();

      final response = await openAIService.generateResponse(text, 'user-123');
      setState(() {
        messages.add({'sender': 'bot', 'text': response.trim()});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: hasStartedChat
              ? ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message['sender'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Card(
                        color: message['sender'] == 'user'
                            ? Colors.blue[50]
                            : Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['sender'] == 'user' ? "You:" : "AI:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(message['text'] ?? ''),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : _buildWelcomeScreen(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter your message...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo at the center
          Image.asset(
            'assets/images/app_icon.png', // Replace with your logo asset path
            height: 100,
          ),
          SizedBox(height: 20),
          // List of FAQs
          Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildFAQItem("What can this chatbot do?"),
          _buildFAQItem("How can I improve my skills?"),
          _buildFAQItem("What are the current trends?"),
          _buildFAQItem("How can I contact support?"),
          _buildFAQItem("Where can I find more information?"),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        question,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}



