import 'package:flutter/material.dart';




class ChatButton extends StatelessWidget {
  const ChatButton({super.key,
  required this.onPressed,
  this.customOpacity = 1,
});

  final VoidCallback onPressed;
  final double customOpacity;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(70, 70),
        maximumSize: const Size(70, 70),
        padding: EdgeInsets.zero, // Paddingをゼロに設定
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Colors.transparent, // 背景色を透明に設定
        shadowColor: Colors.transparent, // シャドウも無効化
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xff3577E6).withValues(alpha: customOpacity),
              Color(0xffD77BFF).withValues(alpha: customOpacity),
            ],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 70,
            minHeight: 70,
          ),
          alignment: Alignment.center,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.chat,
                size: 28,
                color: Colors.white,
              ),
              Text(
                'CHAT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
