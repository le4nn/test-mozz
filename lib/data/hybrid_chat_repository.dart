import '../models/chat.dart';
import '../models/message.dart';
import 'chat_repository.dart';
import 'firestore_chat_repository.dart';

class HybridChatRepository implements ChatRepository {
  final InMemoryChatRepository inMemory;
  final FirestoreChatRepository firestore;

  HybridChatRepository({required this.inMemory, required this.firestore});

  @override
  Future<List<Chat>> getChats() => inMemory.getChats();

  @override
  Future<List<Message>> getMessages(String chatId) =>
      firestore.getMessages(chatId);

  @override
  Future<void> sendText(String chatId, String text) async {
    final chats = await inMemory.getChats();
    Chat? chat;
    for (final c in chats) {
      if (c.id == chatId) {
        chat = c;
        break;
      }
    }
    if (chat != null) {
      await firestore.ensureChat(chat);
    }
    await firestore.sendText(chatId, text);
  }

  @override
  Future<void> sendImage(String chatId, String url) async {
    final chats = await inMemory.getChats();
    Chat? chat;
    for (final c in chats) {
      if (c.id == chatId) {
        chat = c;
        break;
      }
    }
    if (chat != null) {
      await firestore.ensureChat(chat);
    }
    await firestore.sendImage(chatId, url);
  }
}
