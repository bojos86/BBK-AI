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
        colorSchemeSeed: const Color(0xFF7C4DFF),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: const [
            _FeatureCard(
              icon: Icons.document_scanner_outlined,
              title: 'مسح نص من صورة',
              routeBuilder: TextScanScreen.new,
            ),
            _FeatureCard(
              icon: Icons.image_outlined,
              title: 'اختيار صورة',
              routeBuilder: PickImageScreen.new,
            ),
            _FeatureCard(
              icon: Icons.history,
              title: 'السجل',
              routeBuilder: HistoryScreen.new,
            ),
            _FeatureCard(
              icon: Icons.settings_outlined,
              title: 'الإعدادات',
              routeBuilder: SettingsScreen.new,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget Function() routeBuilder;
  const _FeatureCard({required this.icon, required this.title, required this.routeBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () =>
