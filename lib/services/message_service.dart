import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';

/// Service for managing message persistence using Hive
class MessageService {
  static const String _boxName = 'messages';
  static const String _unreadCountKey = 'unread_count';

  /// Get the messages box
  Box<Message> get _messagesBox => Hive.box<Message>(_boxName);

  /// Get all messages
  List<Message> getMessages() {
    return _messagesBox.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Add a new message
  Future<void> addMessage(Message message) async {
    await _messagesBox.put(message.id, message);

    // Increment unread count if it's an agent message
    if (message.sender == 'agent' && !message.isRead) {
      await incrementUnreadCount();
    }
  }

  /// Update a message
  Future<void> updateMessage(Message message) async {
    await _messagesBox.put(message.id, message);
  }

  /// Mark all messages as read
  Future<void> markAllAsRead() async {
    final messages = getMessages();
    for (var message in messages) {
      if (!message.isRead) {
        final updatedMessage = message.copyWith(isRead: true);
        await _messagesBox.put(message.id, updatedMessage);
      }
    }
    await resetUnreadCount();
  }

  /// Get unread message count
  int getUnreadCount() {
    return _messagesBox.values
        .where((msg) => !msg.isRead && msg.sender == 'agent')
        .length;
  }

  /// Increment unread count
  Future<void> incrementUnreadCount() async {
    final box = await Hive.openBox('settings');
    final current = box.get(_unreadCountKey, defaultValue: 0) as int;
    await box.put(_unreadCountKey, current + 1);
  }

  /// Reset unread count
  Future<void> resetUnreadCount() async {
    final box = await Hive.openBox('settings');
    await box.put(_unreadCountKey, 0);
  }

  /// Get stored unread count
  Future<int> getStoredUnreadCount() async {
    final box = await Hive.openBox('settings');
    return box.get(_unreadCountKey, defaultValue: 0) as int;
  }

  /// Initialize with seed messages if empty
  Future<void> initializeSeedMessages() async {
    if (_messagesBox.isEmpty) {
      final now = DateTime.now();
      final seedMessages = [
        Message(
          id: '1',
          text: 'Hi! How can I help you today?',
          sender: 'agent',
          timestamp: now.subtract(const Duration(minutes: 2)),
          isRead: true,
        ),
        Message(
          id: '2',
          text: 'I\'m having trouble with my account',
          sender: 'user',
          timestamp: now.subtract(const Duration(minutes: 1)),
          isRead: true,
        ),
        Message(
          id: '3',
          text: 'I\'d be happy to help! Can you describe the issue?',
          sender: 'agent',
          timestamp: now.subtract(const Duration(minutes: 1)),
          isRead: true,
        ),
        Message(
          id: '4',
          text: 'I can\'t log in anymore',
          sender: 'user',
          timestamp: now,
          isRead: true,
        ),
      ];

      for (var message in seedMessages) {
        await _messagesBox.put(message.id, message);
      }
    }
  }

  /// Clear all messages
  Future<void> clearMessages() async {
    await _messagesBox.clear();
    await resetUnreadCount();
  }

  /// Delete a specific message
  Future<void> deleteMessage(String id) async {
    await _messagesBox.delete(id);
  }
}
