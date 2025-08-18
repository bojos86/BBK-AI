import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// رسالة محادثة بسيطة
class ChatMessage {
  final String role; // "user" أو "assistant"
  final String content;
  ChatMessage(this.role, this.content);
}

/// خدمة بسيطة تستدعي واجهة OpenAI (أو أي مزوّد متوافق) عبر HTTP.
/// ضَع المفتاح عبر --dart-define=OPENAI_API_KEY=xxxxx
/// أو غيّر [apiKey] أدناه (لغرض الاختبار فقط).
class ChatService extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  bool loading = false;

  String get apiKey => const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  final String baseUrl = 'https://api.openai.com/v1/chat/completions';
  final String model = 'gpt-4o-mini';

  Future<void> send(String userText) async {
    messages.add(ChatMessage('user', userText));
    notifyListeners();

    if (apiKey.isEmpty) {
      messages.add(ChatMessage('assistant', 'ضع مفتاح الـ API للتجربة. (OPENAI_API_KEY)'));
      notifyListeners();
      return;
    }

    loading = true;
    notifyListeners();

    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': messages
              .map((m) => {'role': m.role, 'content': m.content})
              .toList(),
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final reply = data['choices'][0]['message']['content'] as String? ?? '…';
        messages.add(ChatMessage('assistant', reply.trim()));
      } else {
        messages.add(ChatMessage('assistant', 'خطأ ${res.statusCode}: ${res.body}'));
      }
    } catch (e) {
      messages.add(ChatMessage('assistant', 'تعذر الاتصال: $e'));
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
