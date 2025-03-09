import 'package:flutter/material.dart';


class MessageBuddle extends StatelessWidget {
  const MessageBuddle({super.key,
  required this.isSender,
  required this.messageText,
  this.warning = false
});

  final bool isSender;
  final String messageText;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isSender)
          ? Color(0xffd2d2d2)
          : (!warning)
            ? messageBuddleBackColor
            : Color(0xfffaeaee),
        borderRadius: BorderRadius.circular(7)
      ),
      child: SelectableText(
        messageText,
        style: TextStyle(
          fontSize: 15,
          color: (warning) ? Color(0xffff577e) :Color(0xff55008b),
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}





Color messageBuddleBackColor = Color(0xfff0f0f0);       // 相手のメッセージ色