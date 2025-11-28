import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../widgets/message_bubble.dart';
import '../../constants/app_constants.dart';
import 'widgets/date_divider.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController controller;
  final EdgeInsetsGeometry padding;
  final Widget itemSpacing;

  const MessageList({
    super.key,
    required this.messages,
    required this.controller,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimens.paddingH,
      vertical: AppDimens.paddingV,
    ),
    this.itemSpacing = const SizedBox(height: AppDimens.paddingV),
  });

  @override
  Widget build(BuildContext context) {
    final items = _buildItems(messages);
    return ListView.separated(
      controller: controller,
      padding: padding,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is _DateItem) return DateDividerWidget(date: item.date);
        if (item is _MessageItem) return MessageBubble(message: item.message);
        return const SizedBox.shrink();
      },
      separatorBuilder: (_, __) => itemSpacing,
      itemCount: items.length,
    );
  }

  List<_Item> _buildItems(List<Message> messages) {
    final list = <_Item>[];
    DateTime? currentDate;
    for (final m in messages) {
      final d = DateTime(m.timestamp.year, m.timestamp.month, m.timestamp.day);
      if (currentDate == null || d.difference(currentDate).inDays != 0) {
        list.add(_DateItem(d));
        currentDate = d;
      }
      list.add(_MessageItem(m));
    }
    return list;
  }
}

abstract class _Item {}

class _DateItem extends _Item {
  final DateTime date;
  _DateItem(this.date);
}

class _MessageItem extends _Item {
  final Message message;
  _MessageItem(this.message);
}
