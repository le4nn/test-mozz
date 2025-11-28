import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat.dart';
import '../models/message.dart';
import 'chat_repository.dart';

class FirestoreChatRepository implements ChatRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _chatsCol =>
      _db.collection('chats');

  @override
  Future<List<Chat>> getChats() async {
    final snap = await _chatsCol.get();
    return snap.docs.map((d) {
        final data = d.data();
        return Chat(
          id: d.id,
          title: data['title'] as String? ?? 'Без имени',
          colorValue: (data['colorValue'] as int?) ?? 0xFF4CAF50,
        );
      }).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    final q =
        await _chatsCol
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp')
            .get();
    return q.docs.map((d) => _fromDoc(chatId, d)).toList();
  }

  @override
  Future<void> sendText(String chatId, String text) async {
    await _chatsCol.doc(chatId).collection('messages').add({
      'type': 'text',
      'text': text,
      'imageUrl': null,
      'isMe': true,
      'status': 'delivered',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> sendImage(String chatId, String url) async {
    await _chatsCol.doc(chatId).collection('messages').add({
      'type': 'image',
      'text': null,
      'imageUrl': url,
      'isMe': true,
      'status': 'delivered',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Message _fromDoc(
    String chatId,
    QueryDocumentSnapshot<Map<String, dynamic>> d,
  ) {
    final data = d.data();
    final typeStr = (data['type'] as String?) ?? 'text';
    final ts = data['timestamp'];
    DateTime time;
    if (ts is Timestamp) {
      time = ts.toDate();
    } else if (ts is DateTime) {
      time = ts;
    } else {
      time = DateTime.now();
    }
    return Message(
      id: d.id,
      chatId: chatId,
      type: typeStr == 'image' ? MessageType.image : MessageType.text,
      text: data['text'] as String?,
      imageUrl: data['imageUrl'] as String?,
      isMe: (data['isMe'] as bool?) ?? false,
      timestamp: time,
      status: _statusFrom((data['status'] as String?) ?? 'sent'),
    );
  }

  MessageStatus _statusFrom(String s) {
    switch (s) {
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }
}
