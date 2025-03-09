// サイドバーでアイコン+テキストを縦に並べるメニューのコンポーネント


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SidebarSquareItem extends StatelessWidget {
  const SidebarSquareItem({super.key,
    required this.icon,
    required this.text,
    required this.onTap
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.white.withValues(alpha: 0.25); // ホバー時の背景色
            }
            return null; // 通常時は色を変更しない
          },
        ),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Icon(icon, color: Colors.white, size: 27)
          ),
          Expanded(
            child: Center(
              child: AutoSizeText(
                text,
                style: TextStyle(color: Colors.white, fontSize: 15),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      )
    );
  }
}
