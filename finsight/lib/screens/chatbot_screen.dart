import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'content': 'Hello Shebly! How can I help you with your finances today?'},
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _controller.clear();
    });

    // Simple AI Response Mock
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (text.toLowerCase().contains('spend')) {
          _messages.add({'role': 'ai', 'content': 'Your food spending increased by ₹3,200 this month. You should watch your Swiggy orders!'});
        } else if (text.toLowerCase().contains('save')) {
          _messages.add({'role': 'ai', 'content': 'You can save more by setting a goal for a laptop or reducing entertainment subscriptions.'});
        } else {
          _messages.add({'role': 'ai', 'content': "That's a great question. I'll analyze your patterns and let you know!"});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('AI Advisor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E3A8A), Color(0xFF7C3AED)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isAI = msg['role'] == 'ai';
                      return Align(
                        alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(msg['content']!),
                        ),
                      );
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('How can I save money?'),
                _buildChip('Can I afford a purchase?'),
                _buildChip('Set a financial goal'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () => _sendMessage(_controller.text),
                mini: true,
                backgroundColor: Colors.white,
                child: const Icon(Icons.send_rounded, color: Color(0xFF7C3AED)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: () => _sendMessage(label),
        backgroundColor: Colors.white.withOpacity(0.1),
        side: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
    );
  }
}
