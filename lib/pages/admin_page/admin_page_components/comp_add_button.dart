import 'package:flutter/material.dart';





final Row compAddButtonChild = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(Icons.add, color: Color(0xff5979ec)),
    SizedBox(width: 1),
    Flexible(child: Text('追加', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff5979ec))))
  ],
);

final compAddButtonStyle = TextButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  backgroundColor: Color(0xffe2e9ff),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  fixedSize: Size(67, 40)
);