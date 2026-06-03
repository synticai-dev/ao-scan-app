import 'package:flutter/material.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Chat")),
      body: Tawk(
        directChatLink:
            'https://tawk.to/chat/6a0d4c6662b0761c3d8d488b/1jp1v4slk',

        visitor: TawkVisitor(name: 'User Name', email: 'user@email.com'),

        onLoad: () {
          debugPrint('Tawk Loaded');
        },

        onLinkTap: (url) {
          debugPrint(url);
        },

        placeholder: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
