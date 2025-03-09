import 'package:flutter/material.dart';


class CloseCircleButton extends StatelessWidget {
  const CloseCircleButton({super.key,
    required this.onPressed,
    this.customIconSize = 27         // アイコンサイズ(任意/デフォ値27)
  });

  final VoidCallback onPressed;
  final double customIconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Color(0xffe0e0e0)
      ),
      icon: Icon(Icons.close, size: customIconSize, color: Color(0xff000000))
    );
  }
}
