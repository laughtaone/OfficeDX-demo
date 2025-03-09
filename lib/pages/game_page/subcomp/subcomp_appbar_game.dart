



import 'package:flutter/material.dart';
import 'package:office_dx/components/close_circle_button.dart';

AppBar subcompAppbarGame({
  required Color backColor,
  required VoidCallback onPressedClose,
  Widget? centerWidget,
  Widget? leftWidget,
  double? customWidth
}) {
  return AppBar(
    title: SizedBox(
      width: customWidth,
      child: Stack(alignment: Alignment.center, children: [
        Align(
          alignment: Alignment.centerRight,
          child: CloseCircleButton(onPressed: onPressedClose)
        ),
        Align(
          alignment: Alignment.center,
          child: centerWidget
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: leftWidget
        ),
      ]),
    ),
    automaticallyImplyLeading: false,
    backgroundColor: backColor,
  );
}