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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF123D7A),
          primary: const Color(0xFF123D7A),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F2FF),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== AppBar (الهيدر مع البانر) =====
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100, // ارتفاع البانر
        flexibleSpace: Image.asset(
          'assets/app_banner.png', // هنا البانر اللي عطيتني صورته
          fit: BoxFit.cover,
        ),
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'تم التحديث بنجاح ✨',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('جرّبي الزر'),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
