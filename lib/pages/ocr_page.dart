import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRPage extends StatefulWidget {
  const OCRPage({super.key});

  @override
  State<OCRPage> createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  File? _image;
  String _text = '';
  bool _busy = false;

  Future<void> _pick() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x == null) return;
    setState(() { _image = File(x.path); _text = ''; });
  }

  Future<void> _recognize() async {
    if (_image == null) return;
    setState(() => _busy = true);
    try {
      final input = InputImage.fromFile(_image!);
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final result = await recognizer.processImage(input);
      await recognizer.close();
      setState(() => _text = result.text.trim().isEmpty ? 'لم يتم العثور على نص.' : result.text);
    } catch (e) {
      setState(() => _text = 'خطأ أثناء التعرف: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_image!, height: 220, fit: BoxFit.cover),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed
