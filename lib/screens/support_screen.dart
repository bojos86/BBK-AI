import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _c = TextEditingController();

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatService>();

    return Scaffold(
      appBar: AppBar(title: const Text('AI Support')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chat.messages.length,
              itemBuilder: (_, i) {
                final m = chat.messages[i];
                final me = m.role == 'user';
                return Align(
                  alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: me ? const Color(0xFF123D7A) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
                    ),
                    child: Text(
                      m.content,
                      style: TextStyle(color: me ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (chat.loading) const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _c,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك…',
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: chat.loading ? null : () async {
                    final t = _c.text.trim();
                    if (t.isEmpty) return;
                    _c.clear();
                    await context.read<ChatService>().send(t);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
