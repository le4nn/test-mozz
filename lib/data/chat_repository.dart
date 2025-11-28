import 'dart:math';

import '../models/chat.dart';
import '../models/message.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();
  Future<List<Message>> getMessages(String chatId);
  Future<void> sendText(String chatId, String text);
  Future<void> sendImage(String chatId, String url);
}

class InMemoryChatRepository implements ChatRepository {
  InMemoryChatRepository._();
  static final InMemoryChatRepository instance = InMemoryChatRepository._();

  factory InMemoryChatRepository() => instance;

  final _rng = Random(3);

  final List<Chat> _chats = [
    const Chat(id: '1', title: 'Виктор Власов', colorValue: 0xFF4CAF50),
    const Chat(id: '2', title: 'Саша Алексеев', colorValue: 0xFFF44336),
    const Chat(id: '3', title: 'Пётр Жаринов', colorValue: 0xFF2196F3),
    const Chat(id: '4', title: 'Алина Жукова', colorValue: 0xFFFF9800),
  ];

  final Map<String, List<Message>> _messages = {};

  List<Message> _seed(String chatId, String title) {
    return [];
  }

  @override
  Future<List<Chat>> getChats() async {
    for (final c in _chats) {
      _messages.putIfAbsent(c.id, () => _seed(c.id, c.title));
    }
    _chats.sort((a, b) {
      final am = _messages[a.id]!;
      final bm = _messages[b.id]!;
      final at =
          am.isNotEmpty
              ? am.last.timestamp
              : DateTime.fromMillisecondsSinceEpoch(0);
      final bt =
          bm.isNotEmpty
              ? bm.last.timestamp
              : DateTime.fromMillisecondsSinceEpoch(0);
      return bt.compareTo(at);
    });
    return List.unmodifiable(_chats);
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    _messages.putIfAbsent(chatId, () => _seed(chatId, ''));
    return List.unmodifiable(_messages[chatId]!);
  }

  @override
  Future<void> sendText(String chatId, String text) async {
    final list = _messages.putIfAbsent(chatId, () => []);
    list.add(
      Message(
        id: '${chatId}_${_rng.nextInt(1 << 32)}',
        chatId: chatId,
        type: MessageType.text,
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
      ),
    );
  }

  @override
  Future<void> sendImage(String chatId, String url) async {
    final list = _messages.putIfAbsent(chatId, () => []);
    list.add(
      Message(
        id: '${chatId}_${_rng.nextInt(1 << 32)}',
        chatId: chatId,
        type: MessageType.image,
        imageUrl: url,
        isMe: true,
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
      ),
    );
  }
}
