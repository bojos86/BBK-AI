import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _controller = TextEditingController();
  final _messages = <_Msg>[
    _Msg('Welcome to BBK AI Support. Ask me anything.', false),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text, true));
      _messages.add(_Msg('AI (stub): I received: "$text"', false)); // plug your API here
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Support')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (_, i) => Align(
                alignment: _messages[i].me ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _messages[i].me ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _messages[i].text,
                    style: TextStyle(color: _messages[i].me ? Colors.white : Colors.black87),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(contentPadding: EdgeInsets.all(12), hintText: 'Type a message'))),
              IconButton(onPressed: _send, icon: const Icon(Icons.send))
            ],
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool me;
  _Msg(this.text, this.me);
}
