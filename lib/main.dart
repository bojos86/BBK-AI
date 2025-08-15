import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BBKOcrApp());
}

class BBKOcrApp extends StatelessWidget {
  const BBKOcrApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBK OCR UAT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const OcrHome(),
    );
  }
}

class OcrHome extends StatefulWidget {
  const OcrHome({super.key});
  @override
  State<OcrHome> createState() => _OcrHomeState();
}

class _OcrHomeState extends State<OcrHome> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _rawText = '';
  late final TextRecognizer _recognizer;

  // النتائج
  String? debit12;
  String? ibanKW30;
  String? bic;
  String? amount;
  String? currency;
  String? beneficiaryName;
  String? beneficiaryBank;
  String? account12;
  String? purpose;
  String? charges;

  @override
  void initState() {
    super.initState();
    _recognizer = TextRecognizer(
      script: TextRecognitionScript.latin, //
