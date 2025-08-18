import 'package:flutter/material.dart';

void main() {
  runApp(const BBKAIApp());
}

class BBKAIApp extends StatelessWidget {
  const BBKAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF123D7A);
    return MaterialApp(
      title: 'BBK AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandBlue,
          primary: brandBlue,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F2FF),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        OcrPage.route: (_) => const OcrPage(),
        PaymentPage.route: (_) => const PaymentPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.document_scanner_outlined),
                title: const Text('OCR — قراءة نص من صورة'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, OcrPage.route);
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Payment — حقول دفع (تجريبي)'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, PaymentPage.route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF123D7A);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brandBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'BBK AI',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // بانر
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/app_banner.png',
                    fit: BoxFit.cover,
                    height: 160,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'تم التحديث بنجاح ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('زرّك شغّال ✅')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandBlue,
                    foregroundColor: Colors.white,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openActions(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// صفحة OCR (Placeholder)
class OcrPage extends StatelessWidget {
  static const route = '/ocr';
  const OcrPage({super.key});

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF123D7A);
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR'),
        backgroundColor: brandBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'هنا بنحط قراءة النص من الصورة (ML Kit).\n'
            'Placeholder حالياً — لما تجهّز الصورة/الصلاحيات نكمّل الربط.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// صفحة Payment (Placeholder)
class PaymentPage extends StatefulWidget {
  static const route = '/payment';
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final form = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    numberCtrl.dispose();
    expiryCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF123D7A);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: brandBlue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Card Holder Name',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: numberCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Card Number'),
                validator: (v) =>
                    (v == null || v.replaceAll(' ', '').length < 12)
                        ? 'Invalid'
                        : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryCtrl,
                      keyboardType: TextInputType.datetime,
                      decoration:
                          const InputDecoration(labelText: 'MM/YY'),
                      validator: (v) =>
                          (v == null || v.length < 4) ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: cvvCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'CVV'),
                      validator: (v) =>
                          (v == null || v.length < 3) ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (form.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('تم إرسال بيانات الدفع (placeholder) ✅'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.lock),
                label: const Text('Pay'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
