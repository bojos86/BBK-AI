import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BBK AI')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/app_banner.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 24),
            _Tile(
              title: 'OCR – مسح نص',
              subtitle: 'من الكاميرا أو من الصورة',
              icon: Icons.document_scanner_outlined,
              onTap: () => Navigator.pushNamed(context, '/ocr'),
            ),
            _Tile(
              title: 'الدفع',
              subtitle: 'حقول البطاقة مع التحقق',
              icon: Icons.credit_card,
              onTap: () => Navigator.pushNamed(context, '/payment'),
            ),
            _Tile(
              title: 'AI Support',
              subtitle: 'دردش مع المساعد',
              icon: Icons.support_agent,
              onTap: () => Navigator.pushNamed(context, '/support'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/support'),
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _Tile({required this.title, required this.subtitle, required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
