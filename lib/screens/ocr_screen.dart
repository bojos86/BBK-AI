import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});
  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  final _picker = ImagePicker();
  String _result = '';
  bool _busy = false;

  Future<void> _pick(ImageSource src) async {
    setState(() => _busy = true);
    try {
      final x = await _picker.pickImage(source: src, imageQuality: 90);
      if (x == null) return;
      final inputImage = InputImage.fromFilePath(x.path);
      final recognizer = TextRecognizer();
      final recognizedText = await recognizer.processImage(inputImage);
      await recognizer.close();

      setState(() => _result = recognizedText.text);
    } catch (e) {
      setState(() => _result = 'خطأ: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR - مسح نص')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('الكاميرا'),
                ),
                ElevatedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('المعرض'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _busy
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
                      ),
                      child: SelectableText(_result.isEmpty ? 'اختَر صورة أو التقط صورة لقراءة النص...' : _result),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
