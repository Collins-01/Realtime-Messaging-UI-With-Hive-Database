import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';

/// Widget for displaying individual message bubbles
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isAgent = message.sender == 'agent';
    final timeFormat = DateFormat('h:mm a');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isAgent
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Agent avatar (only for agent messages)
          if (isAgent) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isAgent
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: message.type == MessageType.emoji ? 8 : 16,
                    vertical: message.type == MessageType.emoji ? 8 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: isAgent ? Colors.white : const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildMessageContent(isAgent),
                ),
                const SizedBox(height: 4),
                // Timestamp
                Text(
                  timeFormat.format(message.timestamp),
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build message content based on type
  Widget _buildMessageContent(bool isAgent) {
    switch (message.type) {
      case MessageType.emoji:
        return Text(message.text, style: const TextStyle(fontSize: 32));

      case MessageType.image:
        if (message.imagePath != null && message.imagePath!.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(message.imagePath!),
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  height: 150,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 48),
                );
              },
            ),
          );
        }
        return const Icon(Icons.image_not_supported);

      case MessageType.text:
        return Text(
          message.text,
          style: TextStyle(
            color: isAgent ? const Color(0xFF1F2937) : Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        );
    }
  }
}
