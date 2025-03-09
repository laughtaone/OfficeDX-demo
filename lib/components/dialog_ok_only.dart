// テキストとOKボタンのみのダイアログを表示するコンポーネント



import 'package:flutter/material.dart';


Future<void> dialogOkOnly({
  required BuildContext context,
  required String dialogText,
  required VoidCallback onPressed
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xffeaf0f8),
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        content: Text(
          dialogText,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center
        ),
        actions: [TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text("OK", style: TextStyle(fontSize: 18)),
          ),
        )],
      );
    },
  );
}