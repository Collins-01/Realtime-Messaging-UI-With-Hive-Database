import 'package:hive/hive.dart';

part 'message.g.dart';

/// Message type enum
@HiveType(typeId: 1)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  emoji,
  @HiveField(2)
  image,
}

/// Message model representing a chat message
@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String sender; // 'user' or 'agent'

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final MessageType type;

  @HiveField(5)
  final bool isRead;

  @HiveField(6)
  final String? imagePath; // For image messages

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
    this.imagePath,
  });

  /// Create a copy of this message with updated fields
  Message copyWith({
    String? id,
    String? text,
    String? sender,
    DateTime? timestamp,
    MessageType? type,
    bool? isRead,
    String? imagePath,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
