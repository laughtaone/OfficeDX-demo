// 引数：説明要素全部を格納したColumn
// 動作：iボタンを表示し、押すと説明ダイアログを返す
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:office_dx/components/close_circle_button.dart';



class CompTileExplain extends StatefulWidget {
  const CompTileExplain({super.key,
    required this.explainColumn,
    this.maxWidth = 700,              // 最大横幅値(任意/デフォ値700)
    this.maxHeight = 470,             // 最大高さ値(任意/デフォ値470)
    this.dialogTitle = '説明',        // ダイアログの冒頭タイトル
    this.iconColor = const Color(0xff888888),
    this.customIconSize = 20
  });

  final Column explainColumn;
  final double maxWidth;
  final double maxHeight;
  final String dialogTitle;
  final Color iconColor;
  final double customIconSize;

  @override
  CompTileExplainState createState() => CompTileExplainState();
}

class CompTileExplainState extends State<CompTileExplain> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: IconButton(
        icon: Icon(Icons.info_outline, size: widget.customIconSize, color: widget.iconColor),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                insetPadding: const EdgeInsets.only(left: 30, right: 30),
                backgroundColor: Colors.white,
                title: SizedBox(
                  height: 45,
                  width: 400,
                  child: Row(
                    children: [
                      Expanded(child: AutoSizeText(widget.dialogTitle)),
                      CloseCircleButton(
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                content: Container(
                  constraints: BoxConstraints(
                    maxWidth: widget.maxWidth,
                    maxHeight: widget.maxHeight
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 2,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: widget.explainColumn
                      ),
                    ),
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }
}





// 引数：該当色・説明タイトル・説明要素個々の説明を格納したColumn
// 動作：説明要素を格納したColumnを返す
Column docTileExplainContent({
  required Color titleColor,
  required String titleText,
  required Column contentColumn,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: titleColor),
            height: 20, width: 30,
          ),
          SizedBox(width: 6),
          Flexible(child: Text(titleText, style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: contentColumn
      ),
      SizedBox(height: 18)
    ],
  );
}

final TextStyle docTileExplainContentTextStyle = TextStyle(fontSize: 13);