// コンポーネントCompTileExplainを利用して、iボタン・チャット機能についての説明ダイアログを表示するサブコンポーネント


import 'package:flutter/material.dart';
import 'package:office_dx/components/robot_icon.dart';
import 'package:office_dx/pages/admin_page/admin_page_components/comp_tile_explain.dart';



CompTileExplain infoChatPage() {
  return CompTileExplain(
    maxWidth: 400,
    maxHeight: 410,
    customIconSize: 22,
    dialogTitle: 'チャット機能について',
    iconColor: Colors.white,
    explainColumn: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 15),
          child: Image.asset('images/about_chat_not_ai.png')
        ),
        Text('本チャット機能は、あいまい検索を実行した結果を、チャット形式で出力するものです。生成AIを用いたチャット機能ではないため、自然な会話はできません。'),
        SizedBox(height: 20),
        Text('プロンプト(=入力されたメッセージ)の内容は、次の基準を元にフィルタリングされるようになっており、この基準を満たしていない場合、検索は実行されません。'),
        SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xfff0f0f0)
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              checkIcon(),
              SizedBox(width: 5),
              Flexible(child: Text('不適切なワードが含まれていないか')),
            ]),
            SizedBox(height: 5),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              checkIcon(),
              SizedBox(width: 5),
              Flexible(child: Text('1文字や記号のみ等のように、検索する意図を持たず入力されたものでないか')),
            ]),
          ]),
        ),
        SizedBox(height: 20),
        Text('また、次のプロンプトに対しては、決まった回答をするようになっています。'),
        SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xfff0f0f0)
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              checkIcon(),
              SizedBox(width: 5),
              Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('あいさつ単体のプロンプト', style: TextStyle(decoration: TextDecoration.underline)),
                Text('あいさつをし返す')
              ])),
            ]),
            SizedBox(height: 5),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              checkIcon(),
              SizedBox(width: 5),
              Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('別れを意図する言葉単体のプロンプト', style: TextStyle(decoration: TextDecoration.underline)),
                Text('チャット終了を促す')
              ])),
            ]),
            SizedBox(height: 5),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              checkIcon(),
              SizedBox(width: 5),
              Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('暇を意味するプロンプト', style: TextStyle(decoration: TextDecoration.underline)),
                Text('ミニゲームを勧める')
              ])),
            ]),
          ]),
        ),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(60, 58, 136, 254),
                Color.fromARGB(60, 225, 146, 254)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RobotIcon(argChatText: (_) {}, needsShowDialog: false, needsTopMargin: false),
            SizedBox(width: 3),
            Flexible(child: Text('プロンプトのサンプルは、チャット画面上のボットアイコンを押してみてください。')),
          ]),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}

final TextStyle docTileExplainContentTextStyle = TextStyle(fontSize: 13);
Icon checkIcon() {
  return Icon(
    Icons.check,
    size: 18,
  );
}