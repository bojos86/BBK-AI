import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(const BBKOCRApp());
}

class BBKOCRApp extends StatelessWidget {
  const BBKOCRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBK OCR UAT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const OCRHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OCRHome extends StatefulWidget {
  const OCRHome({super.key});

  @override
  State<OCRHome> createState() => _OCRHomeState();
}

class _OCRHomeState extends State<OCRHome> {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  String rawText = '';
  Map<String, FieldResult> fields = {};
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    fields = {
      'BBK DEBIT (12)': FieldResult('', validator: (v) => _isAccount12(v)),
      'IBAN (KW, 30)': FieldResult('', validator: (v) => _isKWIban30(v)),
      'BIC/SWIFT (8/11)': FieldResult('', validator: (v) => _isBic(v)),
      'Amount': FieldResult('', validator: (v) => _isAmount(v)),
      'Currency': FieldResult('', validator: (v) => _isCurrency(v)),
      'Beneficiary': FieldResult('', validator: (v) => v.trim().isNotEmpty),
      'Ben Bank': FieldResult('', validator: (v) => v.trim().isNotEmpty),
      'Account No.': FieldResult('', validator: (v) => _isAccount12(v)),
      'Purpose': FieldResult('', validator: (v) => v.trim().isNotEmpty),
      'Charges': FieldResult('', validator: (v) => v.trim().isNotEmpty),
    };
  }

  Future<void> _pick(ImageSource source) async {
    try {
      setState(() => busy = true);
      final x = await _picker.pickImage(source: source, imageQuality: 85);
      if (x == null) return;
      final inputImage = InputImage.fromFilePath(x.path);
      final res = await _recognizer.processImage(inputImage);
      rawText = res.text;
      _parse(rawText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء القراءة: $e')),
      );
    } finally {
      setState(() => busy = false);
    }
  }

  void _parse(String t) {
    _reset();

    final text = t.replaceAll('\n', ' ').replaceAll('\r', ' ').trim();

    // IBAN الكويت: KW + 28 خانة بعدها (الإجمالي 30)
    final ibanKw = RegExp(r'\bKW[0-9A-Z]{28}\b', caseSensitive: false)
        .firstMatch(text)
        ?.group(0);
    if (ibanKw != null) fields['IBAN (KW, 30)']!.value = ibanKw.toUpperCase();

    // BIC 8 أو 11
    final bic = RegExp(r'\b[A-Z0-9]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?\b')
        .firstMatch(text)
        ?.group(0);
    if (bic != null) fields['BIC/SWIFT (8/11)']!.value = bic.toUpperCase();

    // العملة (KWD غالبًا)
    final ccy = RegExp(r'\bKWD\b|\bKW\b', caseSensitive: false)
        .firstMatch(text)
        ?.group(0);
    if (ccy != null) fields['Currency']!.value = 'KWD';

    // المبلغ (أرقام قد تحتوي فواصل أو شرطات)
    final amt = RegExp(r'(\d{1,3}([,.\s]\d{3})*([.,]\d{1,2})?)')
        .firstMatch(text)
        ?.group(0);
    if (amt != null) fields['Amount']!.value = amt.replaceAll(' ', '');

    // رقم الحساب 12 خانة (أول ظهور)
    final acc12 = RegExp(r'\b\d{12}\b').firstMatch(text)?.group(0);
    if (acc12 != null) {
      fields['BBK DEBIT (12)']!.value = acc12;
      fields['Account No.']!.value = acc12;
    }

    // اسم المستفيد (heuristic بسيط)
    final benMatch = RegExp(
            r'(Beneficiary Name[:\s\-]+)([A-Za-z0-9./,&\-\s]{3,})',
            caseSensitive: false)
        .firstMatch(t);
    if (benMatch != null) {
      fields['Beneficiary']!.value = benMatch.group(2)!.trim();
    }

    // بنك المستفيد (heuristic)
    final bankMatch =
        RegExp(r'(Ben(eficiary)? Bank[:\s\-]+)([A-Za-z0-9./,&\-\s]{3,})',
                caseSensitive: false)
            .firstMatch(t);
    if (bankMatch != null) {
      fields['Ben Bank']!.value = bankMatch.group(3)!.trim();
    }

    // Purpose
    final purposeMatch =
        RegExp(r'(Purpose[:\s\-]+)([A-Za-z0-9./,&\-\s]{3,})',
                caseSensitive: false)
            .firstMatch(t);
    if (purposeMatch != null) {
      fields['Purpose']!.value = purposeMatch.group(2)!.trim();
    }

    // Charges
    final chargesMatch =
        RegExp(r'(Charges[:\s\-]+)([A-Za-z0-9./,&\-\s]{2,})',
                caseSensitive: false)
            .firstMatch(t);
    if (chargesMatch != null) {
      fields['Charges']!.value = chargesMatch.group(2)!.trim();
    }

    setState(() {});
  }

  // ----------------- Validators -----------------

  bool _isAccount12(String v) => RegExp(r'^\d{12}$').hasMatch(v.trim());

  bool _isBic(String v) =>
      RegExp(r'^[A-Z0-9]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$')
          .hasMatch(v.trim());

  bool _isCurrency(String v) => v.toUpperCase() == 'KWD';

  bool _isAmount(String v) =>
      RegExp(r'^\d{1,3}([,.\s]?\d{3})*([.,]\d{1,2})?$').hasMatch(v.trim());

  bool _isKWIban30(String v) {
    final s = v.replaceAll(' ', '').toUpperCase();
    if (!RegExp(r'^KW[0-9A-Z]{28}$').hasMatch(s)) return false;
    return _ibanMod97(s) == 1;
  }

  /// حساب Mod-97 للـ IBAN
  int _ibanMod97(String iban) {
    final re = (iban.substring(4) + iban.substring(0, 4))
        .toUpperCase()
        .replaceAll(' ', '');
    final sb = StringBuffer();
    for (final ch in re.runes) {
      final c = String.fromCharCode(ch);
      if (RegExp(r'[0-9]').hasMatch(c)) {
        sb.write(c);
      } else {
        final code = c.codeUnitAt(0) - 55; // A->10
        sb.write(code);
      }
    }
    // احسب الباقي بتجزئة لتفادي الأرقام الضخمة
    String num = sb.toString();
    int carry = 0;
    for (int i = 0; i < num.length; i += 7) {
      final part = '$carry${num.substring(i, i + 7 > num.length ? num.length : i + 7)}';
      carry = int.parse(part) % 97;
    }
    return carry;
  }

  // ----------------- UI -----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BBK OCR UAT')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: busy ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Scan (Camera)'),
                ),
                OutlinedButton.icon(
                  onPressed: busy ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload (Gallery)'),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () {
                          setState(() {
                            rawText = '';
                            _reset();
                          });
                        },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (rawText.isNotEmpty)
                    _panel(
                      title: 'OCR Text',
                      child: SelectableText(
                        rawText,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  _panel(
                    title: 'Parsed fields (strict rules)',
                    child: Column(
                      children: fields.entries.map((e) {
                        final ok = e.value.validator(e.value.value);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 170,
                                child: Text(e.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: e.value.value,
                                  onChanged: (v) =>
                                      setState(() => e.value.value = v),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    suffixIcon: Icon(
                                      ok ? Icons.check_circle : Icons.error,
                                      color:
                                          ok ? Colors.green : Colors.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class FieldResult {
  FieldResult(this.value, {required this.validator});
  String value;
  bool Function(String) validator;
}
