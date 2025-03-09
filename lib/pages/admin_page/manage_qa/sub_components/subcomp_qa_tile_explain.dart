// コンポーネントCompTileExplainを利用して、iボタン・Q&Aタイル説明ダイアログを表示するサブコンポーネント



import 'package:flutter/material.dart';
import 'package:office_dx/pages/admin_page/admin_page_components/comp_tile_explain.dart';


CompTileExplain sumcompQaTileExplain() {
  return CompTileExplain(
    maxWidth: 450,
    maxHeight: 470,
    explainColumn: Column(
      children: [
        Container(
          width: 340,
          margin: const EdgeInsets.only(top: 15, bottom: 15),
          child: Image.asset('images/qa_tile_explanation.png')
        ),
        docTileExplainContent(
          titleColor: Color(0xff50aad8),
          titleText: 'カテゴリ',
          contentColumn: Column(
            children: [
              Text('質問が分類されているカテゴリです。', style: docTileExplainContentTextStyle)
            ],
        )
        ),
        docTileExplainContent(
          titleColor: Color(0xfff89595),
          titleText: '質問文',
          contentColumn: Column(
            children: [
              Text('登録されている質問文が表示されます。最大2行まで表示され、それ以降の文字は省略されます。', style: docTileExplainContentTextStyle)
            ],
          )
        ),
        docTileExplainContent(
          titleColor: Color(0xfff9dc84),
          titleText: '回答文',
          contentColumn: Column(
            children: [
              Text('登録されている回答文が表示されます。最大2行まで表示され、それ以降の文字は省略されます。', style: docTileExplainContentTextStyle)
            ],
          )
        ),
        docTileExplainContent(
          titleColor: Color(0xffc7e3a9),
          titleText: '作成日時',
          contentColumn: Column(
            children: [
              Text(
                'そのQ&Aを最初にアップロードした日時です。なお内容を変更しても、この日時は更新されません。',
                style: docTileExplainContentTextStyle
              ),
            ],
          )
        ),
        docTileExplainContent(
          titleColor: Color(0xff94d5f2),
          titleText: '最終更新日時',
          contentColumn: Column(
            children: [
              Text(
                '最初にそのQ&Aをアップロードしてから更新がない場合は表示されません。アップロード内容を変更される度に、この日時が更新されます。',
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
                child: Text('このボタンを押し「OK」を押すと、そのQ&Aが削除されます。', style: docTileExplainContentTextStyle)
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