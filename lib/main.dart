import 'package:flutter/material.dart';

void main() => runApp(const BBKAIApp());

class BBKAIApp extends StatelessWidget {
  const BBKAIApp({super.key});

  static const Color bbkBlue = Color(0xFF123D7A);
  static const Color bg = Color(0xFFF8F2FF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBK AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: bbkBlue,
          primary: bbkBlue,
        ),
        scaffoldBackgroundColor: bg,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/ocr': (_) => const OcrPage(),
        '/pay': (_) => const PaymentPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BBKAIApp.bbkBlue,
        foregroundColor: Colors.white,
        title: const Text('BBK AI', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/app_banner.png',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'تم التحديث بنجاح ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/ocr'),
                        icon: const Icon(Icons.document_scanner_outlined),
                        label: const Text('OCR'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/pay'),
                        icon: const Icon(Icons.credit_card),
                        label: const Text('الدفع'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                FilledButton.tonalIcon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جرّبتِ الزر ✅')),
                    );
                  },
                  icon: const Icon(Icons.touch_app),
                  label: const Text('جرّبي الزر'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('+ FAB')),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// شاشة OCR Placeholder (بدون باكجات عشان الـ CI)
class OcrPage extends StatelessWidget {
  const OcrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR (Placeholder)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.document_scanner_outlined, size: 80),
              const SizedBox(height: 16),
              const Text(
                'مكان الـ OCR\n(لاحقًا نفعّل مكتبة ML)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('حالياً تجريبي — بدون مكتبة')),
                  );
                },
                child: const Text('جرّب قراءة صورة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// شاشة دفعات بسيطة (حقول تجريبية)
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _form = GlobalKey<FormState>();
  final _card = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  final _name = TextEditingController();

  @override
  void dispose() {
    _card.dispose();
    _expiry.dispose();
    _cvv.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع (تجريبي)')),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'اسم حامل البطاقة',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'إلزامي' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _card,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'رقم البطاقة',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().length < 12) ? 'رقم غير صحيح' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiry,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: 'MM/YY',
                        prefixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || !v.contains('/')) ? 'أدخل التاريخ' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvv,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.length < 3) ? 'غير صحيح' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إدخال بيانات الدفع (تجريبي) ✅')),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('دفع الآن'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
