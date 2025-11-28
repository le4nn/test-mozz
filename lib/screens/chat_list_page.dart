import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../data/repository_provider.dart';
import 'chat_page/chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _search = TextEditingController();
  List<Chat> _chats = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final chats = await Repo.instance.getChats();
    if (!mounted) return;
    setState(() {
      _chats = chats;
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _search.text.trim().isEmpty
            ? _chats
            : _chats
                .where(
                  (c) => c.title.toLowerCase().contains(
                    _search.text.toLowerCase(),
                  ),
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Чаты',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 64,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Поиск',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF1F2F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = filtered[index];
                return FutureBuilder<List<Message>>(
                  future: Repo.instance.getMessages(chat.id),
                  builder: (context, snapshot) {
                    final msgs = snapshot.data ?? const <Message>[];
                    final last = msgs.isNotEmpty ? msgs.last : null;
                    final subtitle =
                        last == null
                            ? ''
                            : last.isMe
                            ? 'Вы: ${last.type == MessageType.text ? (last.text ?? '') : 'Фото'}'
                            : (last.type == MessageType.text
                                ? (last.text ?? '')
                                : 'Фото');
                    final time = last?.timestamp;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(chat.colorValue),
                        child: Text(
                          chat.initials,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(chat.title),
                      subtitle: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        time == null ? '' : _formatTimeOrDate(time),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatPage(chat: chat),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOrDate(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(time.year, time.month, time.day);
    if (dateOnly == today) {
      final h = time.hour.toString().padLeft(2, '0');
      final m = time.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    final dd = time.day.toString().padLeft(2, '0');
    final mm = time.month.toString().padLeft(2, '0');
    final yy = time.year.toString().substring(2);
    return '$dd.$mm.$yy';
  }
}
