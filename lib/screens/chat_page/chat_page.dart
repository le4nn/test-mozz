import 'package:flutter/material.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import '../../data/repository_provider.dart';
import '../../constants/app_constants.dart';
import 'message_list.dart';
import 'widgets/input_bar.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  List<Message> _messages = const [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final msgs = await Repo.instance.getMessages(widget.chat.id);
    _messages = msgs;
    if (mounted) setState(() {});
    _jumpToBottom();
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(chat.colorValue),
              child: Text(
                chat.initials,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text(
                  'В сети',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                messages: _messages,
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingH,
                  vertical: AppDimens.paddingV,
                ),
                itemSpacing: const SizedBox(height: AppDimens.paddingV),
              ),
            ),
            InputBar(
              onAttach: () async {
                await _reload();
              },
              controller: _controller,
              onSend: () async {
                final text = _controller.text.trim();
                if (text.isEmpty) return;
                await Repo.instance.sendText(widget.chat.id, text);
                _controller.clear();
                await _reload();
              },
            ),
          ],
        ),
      ),
    );
  }
}
