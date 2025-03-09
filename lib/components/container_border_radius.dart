// 角丸・背景色付きののContainerをコンポーネント化


import 'package:flutter/material.dart';


Container containerBorderRadius({
  required Widget child,
  Color customColor = Colors.white,     // 背景色
  double customBorderRadius = 10,         // 角丸の具合
  double customPaddingHorizontal = 8,     // 左右の余白
  double customPaddingVertical = 8,       // 上下の余白
  double? customWidth
}) {
  return Container(
    width: customWidth,
    padding: EdgeInsets.symmetric(horizontal: customPaddingHorizontal, vertical: customPaddingVertical),
    decoration: BoxDecoration(
      color: customColor,
      borderRadius: BorderRadius.circular(customBorderRadius)
    ),
    child: child
  );
}