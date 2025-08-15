import 'package:flutter/material.dart';

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
            const Text(
              'أهلاً 👋\nواجهة BBK جاهزة',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                // TODO: ودّينا لصفحة الـ OCR أو الشات لاحقاً
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريباً ✨')),
                );
              },
              child: const Text('ابدأ'),
            ),
          ],
        ),
      ),
    );
  }
}
