import 'package:flutter/material.dart';
import 'screens/chat_list_page.dart';
import 'data/repository_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Repo.tryInitFirebase(preferFirebase: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mozz Messenger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const ChatListPage(),
    );
  }
}
