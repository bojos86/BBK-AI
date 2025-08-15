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
        colorSchemeSeed: const Color(0xFF7C4DFF), // بنفسجي خفيف
        useMaterial3: true,
        fontFamily: 'Roboto',
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
      appBar: AppBar(
        title: const Text('BBK AI'),
        centerTitle: false,
      ),
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
              routeBuilder: TextScanScreen.new, // Placeholder
            ),
            _FeatureCard(
              icon: Icons.image_outlined,
              title: 'اختيار صورة',
              routeBuilder: PickImageScreen.new, // Placeholder
            ),
            _FeatureCard(
              icon: Icons.history,
              title: 'السجل',
              routeBuilder: HistoryScreen.new, // Placeholder
            ),
            _FeatureCard(
              icon: Icons.settings_outlined,
              title: 'الإعدادات',
              routeBuilder: SettingsScreen.new, // Placeholder
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

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.routeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => routeBuilder()),
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// الشاشات الجاية Placeholder عشان التطبيق يفتح بواجهة BBK AI بدون أخطاء.
/// بعدين نبدّلها بكود المسح الفعلي (ML Kit) والتقاط الصور.
class TextScanScreen extends StatelessWidget {
  const TextScanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _ComingSoon(title: 'مسح النص من الصور');
  }
}

class PickImageScreen extends StatelessWidget {
  const PickImageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _ComingSoon(title: 'اختيار صورة من المعرض/الكاميرا');
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _ComingSoon(title: 'سجل الاستخراجات');
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _ComingSoon(title: 'الإعدادات');
  }
}

class _ComingSoon extends StatelessWidget {
  final String title;
  const _ComingSoon({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text(
          'قريبًا 🤍',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
