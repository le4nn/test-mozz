import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class InputBar extends StatelessWidget {
  final VoidCallback onAttach;
  final TextEditingController controller;
  final VoidCallback onSend;

  const InputBar({
    super.key,
    required this.onAttach,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          children: [
            IconButton(
              onPressed: onAttach,
              icon: const Icon(Icons.attach_file),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingH),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(
                    AppDimens.cornerRadiusLarge,
                  ),
                ),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Сообщение',
                  ),
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: AppDimens.inputButtonRadius,
              backgroundColor: AppColors.accent,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
