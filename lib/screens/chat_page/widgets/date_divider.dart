import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class DateDividerWidget extends StatelessWidget {
  final DateTime date;
  const DateDividerWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final text = _format(date);
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.paddingH,
            vertical: AppDimens.paddingV,
          ),
          child: Text(text, style: const TextStyle(color: Colors.black54)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  String _format(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(d.year, d.month, d.day);
    if (dateOnly == today) return 'Сегодня';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd.$mm.$yy';
  }
}
