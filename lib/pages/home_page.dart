import 'package:flutter/material.dart';
import 'ocr_page.dart';
import 'payment_page.dart';
import 'support_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _NavButton('OCR Scanner', Icons.document_scanner, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const OcrPage()));
      }),
      _NavButton('Payment', Icons.credit_card, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentPage()));
      }),
      _NavButton('AI Support', Icons.smart_toy, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()));
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text('BBK AI', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 5,
            child: Image.asset('assets/app_banner.png', fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          const Text('Welcome to BBK AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              children: buttons.map((b) => _CardButton(btn: b)).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('FAB tapped')),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NavButton {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _NavButton(this.title, this.icon, this.onTap);
}

class _CardButton extends StatelessWidget {
  const _CardButton({required this.btn, super.key});
  final _NavButton btn;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btn.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(btn.icon, size: 44, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(btn.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
