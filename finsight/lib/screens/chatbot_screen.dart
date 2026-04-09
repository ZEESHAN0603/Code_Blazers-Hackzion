import 'package:flutter/material.dart';
import '../core/constants.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'content': 'Hello Shebly! I am your AI Financial Advisor. How can I help you optimize your portfolio today?'},
  ];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    
    final int insertIndex = _messages.length;
    _messages.add({'role': 'user', 'content': text});
    _listKey.currentState?.insertItem(insertIndex);
    _controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      final int aiInsertIndex = _messages.length;
      String response = "That's a great question. Based on current market trends, I'd suggest reviewing your fixed costs.";
      if (text.toLowerCase().contains('spend')) {
        response = 'Your food spending is trending 12% higher than last month. Consider local alternatives.';
      } else if (text.toLowerCase().contains('save')) {
        response = 'You could potentially save ₹4,500 more by optimizing your subscriptions.';
      }
      
      _messages.add({'role': 'ai', 'content': response});
      _listKey.currentState?.insertItem(aiInsertIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Financial Intelligence', style: TextStyle(color: AppColors.navyDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _messages.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index, animation) {
                final msg = _messages[index];
                final isAI = msg['role'] == 'ai';
                
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(isAI ? -0.1 : 0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Align(
                      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isAI ? Colors.white : AppColors.accentBlue,
                          borderRadius: BorderRadius.circular(16).copyWith(
                            bottomLeft: isAI ? const Radius.circular(0) : const Radius.circular(16),
                            bottomRight: isAI ? const Radius.circular(16) : const Radius.circular(0),
                          ),
                          boxShadow: AppStyles.softShadow,
                        ),
                        child: Text(
                          msg['content']!,
                          style: TextStyle(color: isAI ? AppColors.navyDark : Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: AppColors.navyDark.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('Analyze my spending'),
                _buildChip('Subscription optimization'),
                _buildChip('Market outlook'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: AppColors.slateBg, borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _sendMessage(_controller.text),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    gradient: AppColors.accentBlueGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
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
        label: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.navyDark)),
        onPressed: () => _sendMessage(label),
        backgroundColor: AppColors.accentBlue.withValues(alpha: 0.05),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
