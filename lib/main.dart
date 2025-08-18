import 'package:flutter/material.dart';
import 'src/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BBKAIApp());
}

class BBKAIApp extends StatelessWidget {
  const BBKAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF123D7A); // BBK blue
    return MaterialApp(
      title: 'BBK AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: const Color(0xFF0D2F63),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4EEFF),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
