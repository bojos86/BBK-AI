import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static const route = '/chat';
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(
        child: Text('هنا محادثة الذكاء الاصطناعي (لاحقًا).'),
      ),
    );
  }
}
