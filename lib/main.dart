import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/chat_service.dart';
import 'screens/home_screen.dart';
import 'screens/ocr_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/support_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BBKAIApp());
}

class BBKAIApp extends StatelessWidget {
  const BBKAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF123D7A); // BBK Navy

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        title: 'BBK AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeColor,
            primary: themeColor,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F2FF),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: themeColor,
            foregroundColor: Colors.white,
          ),
        ),
        routes: {
          '/': (_) => const HomeScreen(),
          '/ocr': (_) => const OcrScreen(),
          '/payment': (_) => const PaymentScreen(),
          '/support': (_) => const SupportScreen(),
        },
      ),
    );
  }
}
