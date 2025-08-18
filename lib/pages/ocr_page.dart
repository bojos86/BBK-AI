import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class OcrPage extends StatefulWidget {
  const OcrPage({super.key});
  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> with WidgetsBindingObserver {
  CameraController? _controller;
  late final Future<void> _init;
  String _text = '—';

  @override
  void initState() {
    super.initState();
    _init = _setup();
  }

  Future<void> _setup() async {
    final cams = await availableCameras();
    final cam = cams.firstWhere((c) => c.lensDirection == CameraLensDirection.back, orElse: () => cams.first);
    _controller = CameraController(cam, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndRecognize() async {
    if (!(_controller?.value.isInitialized ?? false)) return;
    final file = await _controller!.takePicture();
    final input = InputImage.fromFilePath(file.path);
    final recognizer = TextRecognizer();
    final result = await recognizer.processImage(input);
    await recognizer.close();
    setState(() => _text = result.text.isEmpty ? 'No text detected' : result.text);

    // optional: save copy
    final dir = await getTemporaryDirectory();
    await File(file.path).copy('${dir.path}/last_capture.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR Scanner')),
      body: FutureBuilder(
        future: _init,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: _captureAndRecognize,
                label: const Text('Capture & Recognize'),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Text(_text),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
