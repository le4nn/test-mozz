enum MessageType { text, image }

enum MessageStatus { sent, delivered, read }

class Message {
  final String id;
  final String chatId;
  final MessageType type;
  final String? text;
  final String? imageUrl;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.chatId,
    required this.type,
    this.text,
    this.imageUrl,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });
}
