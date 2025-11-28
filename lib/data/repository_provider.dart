import 'package:firebase_core/firebase_core.dart';

import 'chat_repository.dart';
import 'firestore_chat_repository.dart';

class Repo {
  static ChatRepository instance = InMemoryChatRepository.instance;

  static Future<void> tryInitFirebase({bool preferFirebase = true}) async {
    if (!preferFirebase) return;
    try {
      await Firebase.initializeApp();
      final firestoreRepo = FirestoreChatRepository();
      try {
        await firestoreRepo.getChats();
        instance = firestoreRepo;
      } catch (_) {
        instance = InMemoryChatRepository.instance;
      }
    } catch (_) {
      instance = InMemoryChatRepository.instance;
    }
  }
}
