import 'package:flutter/material.dart';



class SearchResultBuddle extends StatelessWidget {
  const SearchResultBuddle({super.key,
    required this.kindText,         // 「見つかったXX」のXX部分のテキスト
    required this.buttonIcon,       // ボタン左側のアイコン
    required this.buttonText,       // ボタンテキスト
    required this.onPressed,

  });

  final String kindText;
  final IconData buttonIcon;
  final String buttonText;
  final void Function() onPressed;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: resultMessageBuddleBackColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '見つかった$kindText',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff55008b),
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: resultButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11)
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(children: [
                    Icon(buttonIcon, size: 19),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        buttonText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ),
                SizedBox(width: 5),
                Icon(Icons.navigate_next_outlined)
              ],
            )
          )
        ],
      ),
    );
  }
}




Color resultMessageBuddleBackColor = Color(0xffeaf0f0);       // 書類・Q&Aの検索結果メッセージ色
Color resultButtonColor = Color(0xffd9e2e2);       // 書類・Q&Aの個々のボタン色