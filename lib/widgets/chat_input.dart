import 'package:flutter/material.dart';

/// Widget for the chat input area at the bottom of the screen
class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback? onEmojiTap;
  final FocusNode? focusNode;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    this.onEmojiTap,
    this.focusNode,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          // Emoji button
          IconButton(
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: Color(0xFF6B7280),
            ),
            onPressed: widget.onEmojiTap,
          ),
          const SizedBox(width: 8),

          // Text input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hasText
                  ? const Color(0xFF4F46E5)
                  : const Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: _hasText ? Colors.white : const Color(0xFF9CA3AF),
                size: 20,
              ),
              onPressed: _hasText ? _handleSend : null,
            ),
          ),
        ],
      ),
    );
  }
}
