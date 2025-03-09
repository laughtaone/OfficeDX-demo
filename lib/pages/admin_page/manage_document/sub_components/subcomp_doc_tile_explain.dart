// コンポーネントCompTileExplainを利用して、iボタン・書類タイル説明ダイアログを表示するサブコンポーネント


import 'package:flutter/material.dart';
import 'package:office_dx/pages/admin_page/admin_page_components/comp_tile_explain.dart';



CompTileExplain sumcompDocTileExplain() {
  return CompTileExplain(
    maxWidth: 450,
    maxHeight: 470,
    explainColumn: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 340,
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            child: Image.asset('images/doc_tile_explanation.png')
          ),
        ),
        docTileExplainContent(
          titleColor: Color(0xfff89595),
          titleText: '書類名',
          contentColumn: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('学生側ページの「書類申請」タブに、次のように表示される書類名です。', style: docTileExplainContentTextStyle),
              SizedBox(height: 5),
              Center(child: SizedBox(width: 300, child: Image.asset('images/doc_tile_explanation_2.png')))
            ],
          )
        ),
        docTileExplainContent(
          titleColor: Color(0xfff9dc84),
          titleText: 'アップロードしたPDFのファイル名',
          contentColumn: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('アップロードしたPDFのファイル名です。', style: docTileExplainContentTextStyle)
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.report_problem_outlined, size: 15),
                  ),
                  SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      '学生がPDFをダウンロードした際、そのファイル名の状態で保存されるため、アップロード時にファイル名に重要な情報が含まれていないことを確認してください。',
                      style: TextStyle(fontSize: 11),
                    ),
                    )
                ],
              )
            ],
          )
        ),
        docTileExplainContent(
          titleColor: Color(0xffc7e3a9),
          titleText: '作成日時',
          contentColumn: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'その書類を最初にアップロードした日時です。\nなお、アップロード内容を変更しても、この日時は更新されません。',
                style: docTileExplainContentTextStyle
              ),
            ],
          )
        ),
        docTileExplainContent(
          titleColor: Color(0xff94d5f2),
          titleText: '最終更新日時',
          contentColumn: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('その書類を最後に編集した日時です。', style: docTileExplainContentTextStyle)
              ),
              Text(
                '最初にアップロードしてから更新がない場合は表示されません。\nアップロード内容を変更される度に、この日時が更新されます。',
                style: docTileExplainContentTextStyle
              )
            ],
          )
        ),
        docTileExplainContent(
          titleColor: Color(0xffd3c3df),
          titleText: '削除',
          contentColumn: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('このボタンを押し「OK」を押すと、その書類が削除されます。', style: docTileExplainContentTextStyle)
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.report_problem_outlined, size: 15),
                  ),
                  SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      '削除処理を実行すると完全にサーバー上から削除されるため、その処理を元に戻すことはできません。',
                      style: TextStyle(fontSize: 11),
                    ),
                    )
                ],
              )
            ],
          )
        ),
      ],
    ),
  );
}

final TextStyle docTileExplainContentTextStyle = TextStyle(fontSize: 13);
