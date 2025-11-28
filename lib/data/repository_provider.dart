import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

import 'chat_repository.dart';
import 'firestore_chat_repository.dart';
import 'hybrid_chat_repository.dart';

class Repo {
  static ChatRepository instance = InMemoryChatRepository.instance;

  static Future<void> tryInitFirebase({bool preferFirebase = true}) async {
    if (!preferFirebase) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized');
      final firestoreRepo = FirestoreChatRepository();
      try {
        await firestoreRepo.getChats();
        instance = HybridChatRepository(
          inMemory: InMemoryChatRepository.instance,
          firestore: firestoreRepo,
        );
        print('Using HybridChatRepository');
      } catch (_) {
        instance = InMemoryChatRepository.instance;
        print(
          'Falling back to InMemoryChatRepository (Firestore check failed)',
        );
      }
    } catch (e) {
      instance = InMemoryChatRepository.instance;
      print('Firebase init failed: $e');
    }
  }
}
