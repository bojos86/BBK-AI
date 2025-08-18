import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _card = TextEditingController();
  final _exp = TextEditingController();
  final _cvv = TextEditingController();
  bool _saving = false;

  String? _validateCard(String? v) {
    final s = v?.replaceAll(RegExp(r'\s+'), '') ?? '';
    if (s.length < 15 || s.length > 19 || !RegExp(r'^\d+$').hasMatch(s)) return 'Invalid card number';
    // simple Luhn
    int sum = 0, alt = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      int n = int.parse(s[i]);
      if (alt % 2 == 1) { n *= 2; if (n > 9) n -= 9; }
      sum += n; alt++;
    }
    if (sum % 10 != 0) return 'Failed Luhn check';
    return null;
  }

  String? _validateExp(String? v) {
    if (v == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) return 'MM/YY';
    final m = int.parse(v.substring(0,2));
    final y = int.parse(v.substring(3,5)) + 2000;
    if (m < 1 || m > 12) return 'Invalid month';
    final now = DateTime.now();
    final end = DateTime(y, m + 1, 0);
    if (end.isBefore(DateTime(now.year, now.month, 1))) return 'Expired';
    return null;
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment authorized at ${DateFormat.Hm().format(DateTime.now())}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Cardholder Name'),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Enter full name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _card,
              decoration: const InputDecoration(labelText: 'Card Number', hintText: '4111 1111 1111 1111'),
              keyboardType: TextInputType.number,
              validator: _validateCard,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _exp,
                    decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                    keyboardType: TextInputType.datetime,
                    validator: _validateExp,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvv,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (v) => (v == null || !RegExp(r'^\d{3,4}$').hasMatch(v)) ? '3-4 digits' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Pay'),
            )
          ],
        ),
      ),
    );
  }
}
