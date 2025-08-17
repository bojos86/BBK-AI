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

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int clicks = 0;

  void _onMainButton() {
    setState(() => clicks++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم الضغط $clicks مرة'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _onFab() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('+ تم الضغط على الزر العائم')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== AppBar (الهيدر) =====
      appBar: AppBar(
        title: const Text('BBK AI'),
        backgroundColor: const Color(0xFF123D7A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // ===== جسم الصفحة =====
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'تم التحديث بنجاح ✨',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFF1B1B1D),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onMainButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123D7A),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text('جرّبي الزر'),
              ),
              const SizedBox(height: 24),
              Text(
                'العدّاد: $clicks',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2D2D35),
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== زر عائم =====
      floatingActionButton: FloatingActionButton(
        onPressed: _onFab,
        backgroundColor: const Color(0xFFE6EBFA),
        foregroundColor: const Color(0xFF0B1D48),
        child: const Icon(Icons.add),
      ),
    );
  }
}
