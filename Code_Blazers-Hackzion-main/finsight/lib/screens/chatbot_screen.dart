import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'content': 'Hello! I am your AI Financial Advisor powered by Mistral. How can I help you optimize your finances today?'},
  ];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ApiService _api = ApiService();
  bool _isTyping = false;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isTyping) return;

    final int insertIndex = _messages.length;
    _messages.add({'role': 'user', 'content': text.trim()});
    _listKey.currentState?.insertItem(insertIndex);
    _controller.clear();

    setState(() => _isTyping = true);

    try {
      final response = await _api.sendChatMessage(text.trim());
      final int aiInsertIndex = _messages.length;
      _messages.add({'role': 'ai', 'content': response});
      _listKey.currentState?.insertItem(aiInsertIndex);
    } catch (e) {
      final int aiInsertIndex = _messages.length;
      _messages.add({'role': 'ai', 'content': "Error: Could not reach the AI Financial Advisor. Please ensure the backend is running.\n($e)"});
      _listKey.currentState?.insertItem(aiInsertIndex);
    } finally {
      if (mounted) setState(() => _isTyping = false);
    }
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
          // Typing indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16).copyWith(bottomLeft: Radius.zero),
                    boxShadow: AppStyles.softShadow,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40,
                        child: LinearProgressIndicator(
                          color: AppColors.accentBlue,
                          backgroundColor: AppColors.slateBg,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Thinking...', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
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
                _buildChip('How can I save more?'),
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
                    enabled: !_isTyping,
                    decoration: const InputDecoration(
                      hintText: 'Ask your AI advisor...',
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
                onTap: _isTyping ? null : () => _sendMessage(_controller.text),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: _isTyping ? null : AppColors.accentBlueGradient,
                    color: _isTyping ? AppColors.slateBg : null,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.send_rounded, color: _isTyping ? AppColors.textLight : Colors.white, size: 20),
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
        onPressed: _isTyping ? null : () => _sendMessage(label),
        backgroundColor: AppColors.accentBlue.withValues(alpha: 0.05),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
