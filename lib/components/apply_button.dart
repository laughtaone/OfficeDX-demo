import 'package:flutter/material.dart';

class ApplyButton extends StatelessWidget {
  final String name;
  final Icon? icon;
  final VoidCallback onPressed;
  final bool needLRPadding;
  final bool needTBPadding;
  final double customFontSize;
  final double customWidth;
  final double customHeight;

  const ApplyButton({
    super.key,
    required this.name,
    this.icon,
    required this.onPressed,
    this.needLRPadding = true,    // 左右のPaddingが不要な場合のみfalseにする（デフォではtrue）
    this.needTBPadding = true,    // 上下のPaddingが不要な場合のみfalseにする（デフォではtrue）
    this.customFontSize = 24,
    this.customWidth = 320,
    this.customHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (needLRPadding) ? 9 : 0,
        vertical: (needTBPadding) ? 9 : 0
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
          ),
        ),
        child: SizedBox(
          width: customWidth,
          height: customHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (icon != null) ? icon! : SizedBox.shrink(),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: customFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
