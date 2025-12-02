import 'package:turbovets_app/models/message.dart';

class MessageConstants {
  MessageConstants._();

  // Auto-reply messages (including emojis)
  static List<Map<String, dynamic>> get autoReplies => [
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
    {
      'text': 'Thank you for contacting our support team!',
      'type': MessageType.text,
    },
    {
      'text': 'I\'m here to assist you with your inquiry.',
      'type': MessageType.text,
    },
    {
      'text': 'Could you please provide more details about your issue?',
      'type': MessageType.text,
    },
    {
      'text': 'I\'ve escalated this to our technical team.',
      'type': MessageType.text,
    },
    {
      'text': 'Your request has been processed successfully.',
      'type': MessageType.text,
    },
    {
      'text': 'Let me verify that information for you.',
      'type': MessageType.text,
    },
    {
      'text': 'I appreciate your patience while I investigate this.',
      'type': MessageType.text,
    },
    {
      'text': 'Is there anything else I can help you with today?',
      'type': MessageType.text,
    },
    {
      'text': 'I\'ve updated your account settings as requested.',
      'type': MessageType.text,
    },
    {
      'text': 'Your feedback is very important to us.',
      'type': MessageType.text,
    },
    {
      'text': 'I\'ll send you a confirmation email shortly.',
      'type': MessageType.text,
    },
    {
      'text': 'That\'s a great question! Let me find the answer.',
      'type': MessageType.text,
    },
    {
      'text': 'I see what you mean. Let me help resolve this.',
      'type': MessageType.text,
    },
    {
      'text': 'Your case has been assigned a priority status.',
      'type': MessageType.text,
    },
    {
      'text': 'I\'ve reviewed your account and everything looks good.',
      'type': MessageType.text,
    },
    {
      'text': 'We\'re working on a solution for you right now.',
      'type': MessageType.text,
    },
    {
      'text': 'I\'ll make sure this gets resolved quickly.',
      'type': MessageType.text,
    },
    {
      'text': 'Thank you for bringing this to our attention.',
      'type': MessageType.text,
    },
    {
      'text': 'I\'ve added a note to your account about this.',
      'type': MessageType.text,
    },
    {
      'text': 'You should see the changes reflected within 24 hours.',
      'type': MessageType.text,
    },
    {'text': 'I\'m happy to help you with that!', 'type': MessageType.text},
    {'text': '👍', 'type': MessageType.emoji},
    {'text': '😊', 'type': MessageType.emoji},
    {'text': '✅', 'type': MessageType.emoji},
    {'text': '🙏', 'type': MessageType.emoji},
  ];
}
