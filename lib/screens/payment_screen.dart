import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _card = TextEditingController();
  final _exp = TextEditingController();
  final _cvv = TextEditingController();

  final _cardMask = MaskTextInputFormatter(mask: '#### #### #### ####', filter: { '#': RegExp(r'\d') });
  final _expMask  = MaskTextInputFormatter(mask: '##/##', filter: { '#': RegExp(r'\d') });

  @override
  void dispose() {
    _name.dispose(); _card.dispose(); _exp.dispose(); _cvv.dispose();
    super.dispose();
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'الاسم على البطاقة'),
                validator: _req,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _card,
                decoration: const InputDecoration(labelText: 'رقم البطاقة'),
                keyboardType: TextInputType.number,
                inputFormatters: [_cardMask],
                validator: (v) => (v != null && v.replaceAll(' ', '').length == 16) ? null : 'رقم غير صالح',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _exp,
                      decoration: const InputDecoration(labelText: 'MM/YY'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [_expMask],
                      validator: (v) => (v != null && v.length == 5) ? null : 'تاريخ غير صالح',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvv,
                      decoration: const InputDecoration(labelText: 'CVV'),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(4)],
                      validator: (v) => (v != null && v.length >= 3) ? null : 'CVV غير صالح',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم التحقق من البيانات (Demo).')),
                    );
                    // هنا تربط بوابة الدفع الفعلية (Stripe/Checkout/...).
                  }
                },
                icon: const Icon(Icons.lock),
                label: const Text('دفع آمن (تجريبي)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
