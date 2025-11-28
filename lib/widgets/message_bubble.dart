import 'package:flutter/material.dart';
import '../models/message.dart';
import '../constants/app_constants.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final theme = Theme.of(context);
    final bg = isMe ? AppColors.accent : AppColors.bubbleIncoming;
    final textColor = isMe ? Colors.white : Colors.black87;

    Widget content;
    if (message.type == MessageType.image) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          message.imageUrl ?? '',
          width: 220,
          fit: BoxFit.cover,
        ),
      );
    } else {
      content = Text(
        message.text ?? '',
        style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      );
    }

    final bubble = Container(
      padding:
          message.type == MessageType.image
              ? EdgeInsets.all(AppDimens.paddingSmall)
              : EdgeInsets.symmetric(
                horizontal: AppDimens.paddingH,
                vertical: AppDimens.paddingV,
              ),
      constraints: BoxConstraints(maxWidth: AppDimens.bubbleMaxWidth),
      decoration: BoxDecoration(
        color: message.type == MessageType.image ? Colors.transparent : bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.cornerRadiusLarge),
          topRight: Radius.circular(AppDimens.cornerRadiusLarge),
          bottomLeft: Radius.circular(
            isMe ? AppDimens.cornerRadiusLarge : AppDimens.cornerRadiusSmall,
          ),
          bottomRight: Radius.circular(
            isMe ? AppDimens.cornerRadiusSmall : AppDimens.cornerRadiusLarge,
          ),
        ),
      ),
      child: content,
    );

    final timeText = Text(
      _formatTime(message.timestamp),
      style: theme.textTheme.labelSmall?.copyWith(color: AppColors.metaText),
    );

    final statusIcon =
        isMe
            ? Icon(
              message.status == MessageStatus.read
                  ? Icons.done_all
                  : message.status == MessageStatus.delivered
                  ? Icons.done_all
                  : Icons.done,
              size: AppDimens.iconSizeSmall,
              color:
                  message.status == MessageStatus.read
                      ? AppColors.accent
                      : AppColors.statusDim,
            )
            : const SizedBox.shrink();

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isMe) const Spacer(),
        Flexible(
          flex: 0,
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              bubble,
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [timeText, const SizedBox(width: 4), statusIcon],
              ),
            ],
          ),
        ),
        if (!isMe) const Spacer(),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
