import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'ocr_page.dart';
import 'payment_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          title: const Text('BBK AI'),
          centerTitle: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: AppTheme.bbkSeed),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // بانر
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/banner.png', fit: BoxFit.cover, height: 160),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'تم التحديث بنجاح ✨',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const OCRPage())),
                          icon: const Icon(Icons.document_scanner_outlined),
                          label: const Text('OCR قراءة نص من صورة'),
                        ),
                        FilledButton.icon(
                          onPressed: () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const PaymentPage())),
                          icon: const Icon(Icons.credit_card),
                          label: const Text('الدفع (حقول بطاقة)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('تم الضغط على +'))),
        child: const Icon(Icons.add),
      ),
    );
  }
}
