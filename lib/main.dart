import 'package:flutter/material.dart';
import 'pages/ocr_page.dart';
import 'pages/chat_page.dart';

void main() {
  runApp(const BBKAIApp());
}

class BBKAIApp extends StatelessWidget {
  const BBKAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBK AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        OcrPage.route: (_) => const OcrPage(),
        ChatPage.route: (_) => const ChatPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BBK AI')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختَر ميزة:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, OcrPage.route),
              child: const Text('📷 OCR (قريبًا)'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => Navigator.pushNamed(context, ChatPage.route),
              child: const Text('💬 Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
