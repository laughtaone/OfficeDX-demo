// 右上に閉じるボタンがあるダイアログを表示するコンポーネント
/* 使い方(雛形)
onPressed: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DialogClose(
        dialogTitle: '',
        onPressedCloseButton: () => Navigator.pop(context),
        content: Column(children: [])
      );
    },
  );
},
*/



import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:office_dx/components/close_circle_button.dart';




class DialogClose extends StatefulWidget {
  const DialogClose({super.key,
    required this.dialogTitle,
    required this.onPressedCloseButton,
    required this.content,
    this.customBackColor = Colors.white,      // 背景色(任意)
    this.customMobileWidth = 350,
    this.customPCWidth = 450,
    this.customTBPadding = 0
  });

  final String dialogTitle;
  final VoidCallback onPressedCloseButton;
  final Widget content;
  final Color customBackColor;
  final double customMobileWidth;
  final double customPCWidth;
  final double customTBPadding;

  @override
  DialogCloseState createState() => DialogCloseState();
}

class DialogCloseState extends State<DialogClose> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;    // 画面の幅を取得
    return AlertDialog(
      backgroundColor: widget.customBackColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: widget.customTBPadding),
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      title: SizedBox(
        width: 200,
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AutoSizeText(widget.dialogTitle, style: TextStyle(fontSize: 22)),
          // -------------------------- 閉じるボタン --------------------------
          CloseCircleButton(
            customIconSize: 24,
            onPressed: widget.onPressedCloseButton
          ),
          // ----------------------------------------------------------------
        ]),
      ),
      content: SizedBox(
        width: (screenWidth > 800) ? widget.customPCWidth : widget.customMobileWidth,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 2,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(right: 3),
              child: widget.content,
            )
          ),
        ),
      ),
    );
  }
}

