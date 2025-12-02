import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:turbovets_app/utils/message_constants.dart';
import '../../models/message.dart';
import '../../services/message_service.dart';
import '../../widgets/chat_input.dart';
import 'components/chat_app_bar.dart';
import 'components/message_list.dart';
import 'components/emoji_picker_panel.dart';
import '../dashboard_screen.dart';

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
      final reply = MessageConstants
          .autoReplies[random.nextInt(MessageConstants.autoReplies.length)];

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
      appBar: ChatAppBar(
        title: 'Support Chat',
        agentName: 'Agent Sarah',
        isAgentOnline: true,
        unreadCount: _unreadCount,
        onMenuPressed: _openDashboard,
        onSearchPressed: () {
          // Search functionality can be added here
        },
        onNotificationPressed: () {
          _messageService.markAllAsRead();
          _updateUnreadCount();
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Messages list
                Expanded(
                  child: MessageList(
                    messages: _messages,
                    scrollController: _scrollController,
                  ),
                ),
                // Emoji picker
                EmojiPickerPanel(
                  isVisible: _showEmojiPicker,
                  onEmojiSelected: _handleEmojiSelected,
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
}
