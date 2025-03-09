// デモ用(デモ用だから処理されたいことをユーザーに伝えるためのウィジェット)

import 'package:flutter/material.dart';


class DemoCaution extends StatelessWidget {
  const DemoCaution({super.key,
    this.customIconSize = 20,
    this.customTextSize = 14,
    this.customLRPadding = 20,
    this.customMessage='デモ版のため内容は反映されません',
    this.isHeightFixed = true,
    this.customWidth = double.infinity
  });

  final double customIconSize;
  final double customTextSize;
  final double customLRPadding;
  final String customMessage;
  final bool isHeightFixed;
  final double customWidth;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: customWidth,
      height: (isHeightFixed) ? 40 : null,
      padding: EdgeInsets.symmetric(horizontal: customLRPadding, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 252, 246, 230),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.amber[800], size: customIconSize),
          SizedBox(width: 4),
          Expanded(
            child: Center(
              child: Text(
                customMessage,
                style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.w800, fontSize: customTextSize)
              ),
            ),
          )
        ],
      ),
    );
  }
}