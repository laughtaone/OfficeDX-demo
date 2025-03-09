import 'package:flutter/material.dart';
import 'package:office_dx/components/dialog_close.dart';



class RobotIcon extends StatelessWidget {
  const RobotIcon({super.key,
    required this.argChatText,
    this.warning = false,
    this.needsShowDialog = true,
    this.customCircleSize,
    this.needsTopMargin = true,
    this.isNotDisplayGreeting = false,
    this.isNotDisplayEndChat = false,
    this.isNotDisplayMiniGame = false,
  });

  final void Function(String) argChatText;
  final bool warning;
  final bool needsShowDialog;
  final double? customCircleSize;
  final bool needsTopMargin;
  final bool isNotDisplayGreeting;
  final bool isNotDisplayEndChat;
  final bool isNotDisplayMiniGame;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero
      ),
      onPressed: (needsShowDialog)
        ? () {
          // --------------------------- ボットアイコンを押した時のダイアログ ---------------------------
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogClose(
                dialogTitle: 'ボットについて',
                customTBPadding: 20,
                onPressedCloseButton: () => Navigator.pop(context),
                content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(
                    child: RobotIcon(
                      argChatText: (_) {},
                      needsShowDialog: false,
                      customCircleSize: 70
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('こんにちは！あなたの疑問を解決するために誕生したボットです。名前はありません。'),
                  SizedBox(height: 13),
                  Text('あなたが入力したプロンプトに対して様々な応答をします。'),
                  SizedBox(height: 13),
                  Text('例えば、次のプロンプトを試してみてください！タップすると簡単に試せます：'),
                  SizedBox(height: 3),
                  SamplePromptButton(text: '変更', subText: '両方の要素が見つかるサンプル', onPressed: () {
                    argChatText('変更');
                    Navigator.pop(context);
                  }),
                  SamplePromptButton(text: 'こんにちは', isUnable: isNotDisplayGreeting, onPressed: () {
                    argChatText('こんにちは');
                    Navigator.pop(context);
                  }),
                  SamplePromptButton(text: 'あ', subText: '質問する意図のないプロンプトの例', onPressed: () {
                    argChatText('あ');
                    Navigator.pop(context);
                  }),
                  SamplePromptButton(text: '<不適切なワード>', subText: '具体的な不適切ワードを回避するためこの表記ですが、このまま送信しても正常に動作します', onPressed: () {
                    argChatText('<不適切なワード>');
                    Navigator.pop(context);
                  }),
                  SamplePromptButton(text: 'さようなら', isUnable: isNotDisplayEndChat, onPressed: () {
                    argChatText('さようなら');
                    Navigator.pop(context);
                  }),
                  SamplePromptButton(text: '退屈です', isUnable: isNotDisplayMiniGame, onPressed: () {
                    argChatText('退屈です');
                    Navigator.pop(context);
                  }),
                  SizedBox(height: 20)
                ])
              );
            },
          );
          // --------------------------------------------------------------------------------------
        }
        : null,
      icon: Container(
        width: (customCircleSize != null) ? customCircleSize : null,
        height: (customCircleSize != null) ? customCircleSize : null,
        margin: (needsTopMargin) ? EdgeInsets.only(top: 5) : null,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: (warning)
            ? null
            : LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                Color(0xff3A87FE),
                Color(0xffE292FE),
                ],
              ),
          color: (warning) ? Color(0xfff88ba4) : null,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Icon(
            (warning) ? Icons.error_outline_outlined : Icons.smart_toy_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}






// プロンプトサンプルのボタン
class SamplePromptButton extends StatefulWidget {
  const SamplePromptButton({super.key,
    required this.text,
    this.subText,
    required this.onPressed,
    this.isUnable = false
  });

  final String text;
  final String? subText;
  final VoidCallback onPressed;
  final bool isUnable;

  @override
  SamplePromptButtonState createState() => SamplePromptButtonState();
}
class SamplePromptButtonState extends State<SamplePromptButton> {
  bool _isButtonOnEnter = false;
  String? subtext;

  @override
  void initState() {
    super.initState();
    setState(() {
      subtext = (widget.isUnable) ? '※設定でオフになっています\n　オフになった場合の応答を試せます' : widget.subText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: MouseRegion(
        cursor: _isButtonOnEnter ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) {
          // カーソルがボタン上に乗ったときの処理
          setState(() {
            _isButtonOnEnter = true;
          });
          // カーソルをクリック可能に変更
        },
        onExit: (_) {
          // カーソルがボタンを離れたときの処理
          setState(() {
            _isButtonOnEnter = false;
          });
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: (subtext != null) ? 10 : 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (widget.isUnable)
                ? [
                  Color.fromARGB((_isButtonOnEnter) ? 10 : 30, 58, 136, 254),
                  Color.fromARGB((_isButtonOnEnter) ? 10 : 30, 225, 146, 254)
                ]
                : [
                  Color.fromARGB((_isButtonOnEnter) ? 40 : 65, 58, 136, 254),
                  Color.fromARGB((_isButtonOnEnter) ? 40 : 65, 225, 146, 254)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              // color: (widget.isUnable) ? Color.fromRGBO(240, 240, 240, (_isButtonOnEnter) ? 0.4 : 1) : null,
              borderRadius: BorderRadius.circular(7)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff5233a3),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: (widget.subText != null) ? 2 : 0),
                    (subtext != null)
                      ? Text(
                        subtext!,
                        style: TextStyle(
                          fontSize: 10,
                          color: (widget.isUnable) ? Color(0xff808080) :Color(0xff694fb0),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                      : SizedBox.shrink()
                  ]),
                ),
                SizedBox(width: 3),
                Text(
                  '試す',
                  style: TextStyle(color: Color(0xff707070)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}