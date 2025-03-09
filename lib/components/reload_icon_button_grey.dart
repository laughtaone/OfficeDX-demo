import 'package:flutter/material.dart';


Padding reloadIconButton({
  required VoidCallback onPressed,
  Color customColor = const Color(0xff888888),
  double customIconSize = 20,
  double customTopPadding = 4
}) {
  return Padding(
    padding: EdgeInsets.only(top: customTopPadding),
    child: IconButton(
      icon: Icon(Icons.refresh_outlined, size: customIconSize, color: customColor),
      onPressed: onPressed
    ),
  );
}