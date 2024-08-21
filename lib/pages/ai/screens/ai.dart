// =======================================================
//                          NEW        
// =======================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/domain/services/services.dart';
import 'package:flutter/material.dart';

class Ai extends ConsumerStatefulWidget {
  const Ai({super.key});

  @override
  _AiState createState() => _AiState();
}

class _AiState extends ConsumerState<Ai> {
  final OpenAIService openAIService = OpenAIService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool hasStartedChat = false;

  // Simulating user login status
  bool isLoggedIn = true;

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

  void _loadConversation(List<Map<String, String>> conversation) {
    setState(() {
      messages = conversation;
      hasStartedChat = true;
    });
  }

  void _startNewConversation() {
    setState(() {
      messages.clear(); // Clear current conversation
      hasStartedChat = false; // Reset chat state
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("AI Chatbot"),
  //     ),
  //     drawer: _buildDrawer(),
  //     body: _buildChatScreen(),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Oppenhomies"),
        actions: [
          if (!isLoggedIn) // Show "Start New Conversation" button if not logged in
            IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: _startNewConversation,
            ),
        ],
      ),
      drawer: isLoggedIn ? _buildDrawer() : null, // Show drawer only if logged in
      body: _buildChatScreen(),
    );
  }

  Widget _buildDrawer() {
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
                    _startNewConversation();
                    Navigator.pop(context); // Close the drawer after starting a new conversation
                  },
                  child: Image.asset(
                    'assets/images/app_icon.png', // Replace with your logo asset path
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
                    // Call a function to load this conversation history
                  },
                ),
                ListTile(
                  title: Text('Example Conversation 2'),
                  onTap: () {
                    Navigator.pop(context);
                    // Call a function to load this conversation history
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: hasStartedChat && messages.isNotEmpty
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
          Image.asset(
            'assets/images/app_icon.png', // Replace with your logo asset path
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




// =======================================================
//                          OLD        
// =======================================================





// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:oppenhomies/styles/spacings.dart';
// import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
// import 'package:oppenhomies/domain/services/services.dart';
// import 'package:flutter/material.dart';

// class Ai extends ConsumerWidget {
//   const Ai({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("AI Chatbot"),
//       ),
//       drawer: 
//         // _buildDrawer(context),
//         Builder(
//           builder: (context) {
//             final chatScreenState = context.findAncestorStateOfType<_ChatScreenState>();
//             return _buildDrawer(context, chatScreenState);
//           },
//         ),
//       body: ChatScreen(),
//     );
//   } 
  
//   Widget _buildDrawer(BuildContext context, _ChatScreenState? chatScreenState) {
//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           SizedBox(height: 50.0),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close the drawer
//                   },
//                   child: Icon(Icons.close),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // Access the method in the ChatScreen state to start a new conversation
//                     // final chatScreenState = context.findAncestorStateOfType<_ChatScreenState>();
//                     chatScreenState?._startNewConversation();
//                     Navigator.pop(context); // Close the drawer after starting a new conversation
//                   },
//                   child: 
//                     // Text("New Conversation"),
//                     Image.asset(
//                       'assets/images/app_icon.png', // Replace with your logo asset path
//                       height: 30,
//                     ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: <Widget>[
//                 ListTile(
//                   title: Text('Example Conversation 1'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Call a function to load this conversation history
//                   },
//                 ),
//                 ListTile(
//                   title: Text('Example Conversation 2'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Call a function to load this conversation history
//                   },
//                 ),
//                 // Add more ListTiles here for additional conversation history examples
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final OpenAIService openAIService = OpenAIService();
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, String>> messages = [];
//   bool hasStartedChat = false;

//   void _sendMessage() async {
//     final text = _controller.text;
//     if (text.isNotEmpty) {
//       setState(() {
//         hasStartedChat = true;
//         messages.add({'sender': 'user', 'text': text});
//       });
//       _controller.clear();

//       final response = await openAIService.generateResponse(text, 'user-123');
//       setState(() {
//         messages.add({'sender': 'bot', 'text': response.trim()});
//       });
//     }
//   }

//   void _loadConversation(List<Map<String, String>> conversation) {
//     setState(() {
//       messages = conversation;
//       hasStartedChat = true;
//     });
//   }

//   void _startNewConversation() {
//     setState(() {
//       messages.clear(); // Clear current conversation
//       hasStartedChat = false; // Reset chat state
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: hasStartedChat && messages.isNotEmpty
//               ? ListView.builder(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     return Align(
//                       alignment: message['sender'] == 'user'
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Card(
//                         color: message['sender'] == 'user'
//                             ? Colors.blue[50]
//                             : Colors.grey[200],
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 message['sender'] == 'user' ? "You:" : "AI:",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 8.0),
//                               Text(message['text'] ?? ''),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 )
//               : _buildWelcomeScreen(),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: "Enter your message...",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: _sendMessage,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWelcomeScreen() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Logo at the center
//           Image.asset(
//             'assets/images/app_icon.png', // Replace with your logo asset path
//             height: 100,
//           ),
//           SizedBox(height: 20),
//           // List of FAQs
//           Text(
//             "Frequently Asked Questions",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10),
//           _buildFAQItem("What can this chatbot do?"),
//           _buildFAQItem("How can I improve my skills?"),
//           _buildFAQItem("What are the current trends?"),
//           _buildFAQItem("How can I contact support?"),
//           _buildFAQItem("Where can I find more information?"),
//         ],
//       ),
//     );
//   }

//   Widget _buildFAQItem(String question) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         question,
//         style: TextStyle(fontSize: 16),
//       ),
//     );
//   }
// }