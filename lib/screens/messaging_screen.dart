import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../models/message.dart';
import '../services/message_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import 'dashboard_screen.dart';

/// Main messaging screen with chat interface
class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final MessageService _messageService = MessageService();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = true;
  int _unreadCount = 0;
  bool _showEmojiPicker = false;

  // Auto-reply messages (including emojis)
  final List<Map<String, dynamic>> _autoReplies = [
    {
      'text': 'I understand. Let me look into that for you.',
      'type': MessageType.text,
    },
    {
      'text': 'Thanks for providing that information!',
      'type': MessageType.text,
    },
    {
      'text': 'I\'ve noted that down. Is there anything else?',
      'type': MessageType.text,
    },
    {'text': 'Let me check our system for you.', 'type': MessageType.text},
    {'text': 'I can help you with that right away.', 'type': MessageType.text},
    {'text': '👍', 'type': MessageType.emoji},
    {'text': '😊', 'type': MessageType.emoji},
    {'text': '✅', 'type': MessageType.emoji},
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Load messages from Hive
  Future<void> _loadMessages() async {
    await _messageService.initializeSeedMessages();
    final messages = _messageService.getMessages();

    setState(() {
      _messages.clear();
      _messages.addAll(messages);
      _isLoading = false;
    });

    _updateUnreadCount();
    _scrollToBottom();

    // Mark all messages as read when viewing
    await _messageService.markAllAsRead();
    _updateUnreadCount();
  }

  /// Update unread count
  void _updateUnreadCount() {
    setState(() {
      _unreadCount = _messageService.getUnreadCount();
    });
  }

  /// Scroll to the bottom of the message list
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Handle sending a new message
  void _handleSendMessage(String text, {MessageType type = MessageType.text}) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
      type: type,
      isRead: true,
    );

    setState(() {
      _messages.add(newMessage);
    });
    _messageService.addMessage(newMessage);
    _scrollToBottom();

    // Trigger auto-reply after 1.5 seconds
    _scheduleAutoReply();
  }

  /// Handle emoji selection
  void _handleEmojiSelected(String emoji) {
    _handleSendMessage(emoji, type: MessageType.emoji);
    setState(() {
      _showEmojiPicker = false;
    });
  }

  /// Schedule an automatic reply from the agent
  void _scheduleAutoReply() {
    Timer(const Duration(milliseconds: 1500), () {
      final random = Random();
      final reply = _autoReplies[random.nextInt(_autoReplies.length)];

      final agentMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: reply['text'],
        sender: 'agent',
        timestamp: DateTime.now(),
        type: reply['type'],
        isRead: false, // Agent messages start as unread
      );

      setState(() {
        _messages.add(agentMessage);
      });
      _messageService.addMessage(agentMessage);
      _updateUnreadCount();
      _scrollToBottom();
    });
  }

  /// Navigate to dashboard screen
  void _openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Messages list
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
                ),
                // Emoji picker
                if (_showEmojiPicker)
                  SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        _handleEmojiSelected(emoji.emoji);
                      },
                      config: const Config(
                        height: 256,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(emojiSizeMax: 28),
                      ),
                    ),
                  ),
                // Input area
                ChatInput(
                  onSendMessage: (text) => _handleSendMessage(text),
                  onEmojiTap: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                    });
                  },
                ),
              ],
            ),
    );
  }

  /// Build the custom AppBar
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Menu button
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: _openDashboard,
                ),
                // Title and subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Support Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Agent Sarah • Online',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Search icon
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    // Search functionality can be added here
                  },
                ),
                // Bell icon with notification badge
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Mark all as read
                        _messageService.markAllAsRead();
                        _updateUnreadCount();
                      },
                    ),
                    if (_unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            _unreadCount > 9 ? '9+' : _unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
