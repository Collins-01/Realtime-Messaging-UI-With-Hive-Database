import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/message.dart';
import '../../services/message_service.dart';
import '../../utils/message_constants.dart';

class MessagingViewModel extends ChangeNotifier {
  final MessageService _messageService = MessageService();
  final ScrollController scrollController = ScrollController();

  List<Message> _messages = [];
  bool _isLoading = true;
  int _unreadCount = 0;
  bool _showEmojiPicker = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;
  bool get showEmojiPicker => _showEmojiPicker;

  Future<void> initialize() async {
    await _loadMessages();
  }

  Future<void> _loadMessages() async {
    await _messageService.initializeSeedMessages();
    final loadedMessages = _messageService.getMessages();

    _messages = loadedMessages;
    _isLoading = false;
    notifyListeners();

    _updateUnreadCount();
    _scrollToBottom();

    await _messageService.markAllAsRead();
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    _unreadCount = _messageService.getUnreadCount();
    notifyListeners();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage(String text, {MessageType type = MessageType.text}) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
      type: type,
      isRead: true,
    );

    _messages.add(newMessage);
    notifyListeners();

    _messageService.addMessage(newMessage);
    _scrollToBottom();
    _scheduleAutoReply();
  }

  /// Handle emoji selection
  void handleEmojiSelected(String emoji) {
    sendMessage(emoji, type: MessageType.emoji);
    _showEmojiPicker = false;
    notifyListeners();
  }

  void toggleEmojiPicker() {
    _showEmojiPicker = !_showEmojiPicker;
    notifyListeners();
  }

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
        isRead: false,
      );

      _messages.add(agentMessage);
      notifyListeners();

      _messageService.addMessage(agentMessage);
      _updateUnreadCount();
      _scrollToBottom();
    });
  }

  void markAllAsRead() {
    _messageService.markAllAsRead();
    _updateUnreadCount();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
