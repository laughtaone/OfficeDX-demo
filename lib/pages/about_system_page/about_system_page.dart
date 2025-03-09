import 'package:flutter/material.dart';
import 'package:office_dx/components/common_sidebar_pages_appbar.dart';
import 'package:office_dx/components/open_link_button.dart';


double maxWidth = 550;


class AboutSystemPage extends StatefulWidget {
  const AboutSystemPage({super.key});

  @override
  AboutSystemPageState createState() => AboutSystemPageState();
}

class AboutSystemPageState extends State<AboutSystemPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonSidebarPagesAppbar(
        title: '本システムについて',
        iconData: Icons.info_outline
      ),
      body: Scrollbar(
        controller: _scrollController,
        thickness: 5,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Container(
              color: Colors.white,
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // -------------------------------- 冒頭案内 --------------------------------
                  sectionTile(
                    columnChildren: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Image.asset('images/about_system/about_system_1.png')
                      ),
                      bodyText('本システムは、本校の情報システム工学コースにおける、2024年度 エンジニアリングデザインIの授業内の1グループで計画・開発した事務DX支援システムです（実際に導入されたわけではありません）。'),
                      OpenLinkButton(
                        customBackColor: Color(0xffe4eff7),
                        url: 'https://www.dropbox.com/scl/fi/7g97jjcxoty07yiofxzld/DX_2408_.pdf?rlkey=fcavhglkwbi91tf4snoqsrhmv&st=vscgwnqz&dl=0',
                        buttonChild: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.language),
                          SizedBox(width: 4),
                          Text('概要紹介資料を見る - Dropbox', textAlign: TextAlign.center,)
                        ])
                      )
                    ]
                  ),
                  // -------------------------------------------------------------------------
        
                  // --------------------------------- 開発手法 -------------------------------
                  sectionTile(
                    columnChildren: [
                      sectionTitle('開発手法'),
                      bodyText('本システムは、次に示す手法・想定で開発しました。', customTBPadding: 10, customTextAlign: TextAlign.center, needsBold: true),
                      stepPadding(),
                      // - - - - - - - - 内容 - - - - - - - - -
                      listWrite('開発言語/フレームワーク：Dart/Flutter'),
                      listWrite('開発環境：MacBook Air(M1/2020/macOS Sequoia 15.2)・VSCode'),
                      listWrite('コード管理：Git・GitHub'),
                      listWrite('バックエンド：Firebase'),
                      listWrite('ストレージ：Firebase Storage', needsLeftPadding: true),
                      listWrite('データ管理：Firebase Cloud Firestore', needsLeftPadding: true),
                      listWrite('ログイン認証：Firebase Authentication', needsLeftPadding: true),
                      OpenLinkButton(
                        customTopPadding: 3,
                        customBackColor: Color(0xffe4eff7),
                        url: 'https://www.dropbox.com/scl/fi/dzdvcje6ksjz898y7slox/DX_Firebase.pdf?rlkey=ztn6n3urayz8klvti4pe6jy7c&st=ererawbn&dl=0',
                        buttonChild: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.language),
                          SizedBox(width: 4),
                          Text('Firebase構造資料を見る - Dropbox', textAlign: TextAlign.center,)
                        ])
                      ),
                      listWrite('設計書作成：Notion'),
                      listWrite('サイトデザイン案作成：Figma・Keynote'),
                      listWrite('想定利用環境：Web\n(iOSネイティブ環境向けのビルドにも対応できるよう開発)'),
                      // - - - - - - - - - - - - - - - - - - -
                      stepPadding(),
                    ]
                  ),
                  // -------------------------------------------------------------------------

                  // ------------------------------- 開発手順説明 ------------------------------
                  sectionTile(
                    columnChildren: [
                      sectionTitle('開発手順'),
                      bodyText('本システムは、次のような流れで開発しました。', customTBPadding: 10, customTextAlign: TextAlign.center, needsBold: true),
                      stepPadding(),
                      // - - - - - - - - - 1 - - - - - - - - -
                      stepTitle(
                        icon: Icons.looks_one_outlined,
                        text: 'アイデアをいただき、内容を練る。',
                      ),
                      // - - - - - - - - - - - - - - - - - - -
                      stepPadding(),
                      // - - - - - - - - - 2 - - - - - - - - -
                      stepTitle(
                        icon: Icons.looks_two_outlined,
                        text: '事務室の職員の方にヒアリングを実施し、事務室における課題を発見する。'
                      ),
                      // OpenLinkButton(
                      //   customBackColor: Color(0xffe4eff7),
                      //   url: '',
                      //   buttonChild: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                      //     Icon(Icons.language),
                      //     SizedBox(width: 4),
                      //     Text('ヒアリングログ資料を見る - Dropbox', textAlign: TextAlign.center,)
                      //   ])
                      // ),
                      // - - - - - - - - - - - - - - - - - - -
                      stepPadding(),
                      // - - - - - - - - - 3 - - - - - - - - -
                      stepTitle(
                        icon: Icons.looks_3_outlined,
                        text: '"その課題をDX化によって解決するアプリ"としてアイデアを膨らませ、設計書やUI案を作る。'
                      ),
                      OpenLinkButton(
                        customBackColor: Color(0xffe4eff7),
                        url: 'https://www.dropbox.com/scl/fi/z2jyufw1m00uar9aodhdl/office-dx_.pdf?rlkey=7mv69c11t88fn0a23a1sahnp0&st=2xxwmh82&dl=0',
                        buttonChild: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.language),
                          SizedBox(width: 4),
                          Text('設計書資料を見る - Dropbox', textAlign: TextAlign.center,)
                        ])
                      ),
                      OpenLinkButton(
                        customBackColor: Color(0xffe4eff7),
                        url: 'https://www.dropbox.com/scl/fi/y18knbsyhdfy3pksakvdp/office-dx_UI.png?rlkey=3z7u4640tydocb4dmtqz56u2p&st=xpvrhuz7&dl=0',
                        buttonChild: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.language),
                          SizedBox(width: 4),
                          Text('デザイン案資料を見る - Dropbox', textAlign: TextAlign.center,)
                        ])
                      ),
                      // - - - - - - - - - - - - - - - - - - -
                      stepPadding(),
                      // - - - - - - - - - 4 - - - - - - - - -
                      stepTitle(
                        icon: Icons.looks_4_outlined,
                        text: '開発を進める。'
                      ),
                      // - - - - - - - - - - - - - - - - - - -
                      stepPadding(),
                    ]
                  ),
                  // -------------------------------------------------------------------------
        
        
                  // --------------------------------- 機能一覧 -------------------------------
                  sectionTile(
                    columnChildren: [
                      sectionTitle('機能一覧'),
                      // - - - - - - - - - - 書類 - - - - - - - - - -
                      sectionSubTitle('書類'),
                      bodyText('トップ画面の下部メニューの左側の項目を押すと、現在入手可能な申請書類一覧が表示されます。'),
                      bodyText('各書類を押すとその書類のPDFファイルのページに遷移します。'),
                      // - - - - - - - - - - - - - - - - - - - - - -
                      subtitlePadding(),
                      // - - - - - - - - - - Q&A - - - - - - - - - -
                      sectionSubTitle('Q&A'),
                      bodyText('トップ画面の下部メニューの右側の項目を押すと、事務室に寄せられるQ&A一覧が表示されます。'),
                      bodyText('各Q&Aを押すとそのQ&Aの詳細ページに遷移します。'),
                      // - - - - - - - - - - - - - - - - - - - - - -
                      subtitlePadding(),
                      // - - - - - - - - - - 検索 - - - - - - - - - -
                      sectionSubTitle('検索'),
                      bodyText('トップ画面に表示される検索ボックスにテキストを入れ、検索を実行すると、該当する書類・Q&Aが表示されます。'),
                      // - - - - - - - - - - - - - - - - - - - - - -
                      subtitlePadding(),
                      // - - - - - - - - - チャット - - - - - - - - -
                      sectionSubTitle('チャット'),
                      bodyText('トップ画面の右下に表示されているチャットボタンを押すとチャット画面が表示され、プロンプトに合う書類・Q&Aが表示されます。'),
                      bodyText('不適切な言葉を含むプロンプトは実行されず、遊び心のあるプロンプトには少し工夫のある応答します。'),
                      bodyText('例：'),
                      Table(
                        border: TableBorder.all(color: Colors.black),
                        children: [
                          // ヘッダー行
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText('プロンプトの状況', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText('応答', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText('プロンプトの例', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          // データ行をリストから生成
                          ...chatPromptTableData.map((row) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectableText(row['プロンプトの状況'] ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectableText(row['応答'] ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectableText(row['例'] ?? ''),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      // - - - - - - - - - - - - - - - - - - - - - -
                      subtitlePadding(),
                      // - - - - - - - - 管理者ページ - - - - - - - -
                      sectionSubTitle('管理者ページ'),
                      bodyText('トップ画面のサイドバーに表示されている管理者ログインページを押すと管理者ページが表示され、このページから、書類ページ・Q&Aページに掲載するものを、追加・編集・削除の操作で管理することができます。'),
                      bodyText('このページにアクセスするにはログインが必要となり、学生はアクセスできません。'),
                      // - - - - - - - - - - - - - - - - - - - - - -
                      subtitlePadding(),
                      // - - - - - - - - - ミニゲーム - - - - - - - -
                      sectionSubTitle('ミニゲーム'),
                      bodyText('チャット画面から、暇やゲームを連想するプロンプトを送ると、ミニゲーム画面への案内が表示され、このページのみから、ミニゲームのページにアクセスできます。'),
                      bodyText('例えば「暇」や「ゲーム」と送るとアクセスできます。'),
                      bodyText('このミニゲームは次々に表示されるいくつかのテキストから「産技高専」or「TMCIT」を探し、見つけた個数をスコアとして競うミニゲームです。'),
                      bodyText('これは、あくまでユーモアとしてのおまけ機能です。'),
                      // - - - - - - - - - - - - - - - - - - - - - -
                      subtitlePadding(),
                    ]
                  ),
                  // -------------------------------------------------------------------------
                ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}





Container sectionTile({required List<Widget> columnChildren}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 25),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Color(0xFFf4f6fb),
      borderRadius: BorderRadius.circular(7)
    ),
    child: Column(children: columnChildren)
  );
}

Container sectionTitle(
  String text, {
    double customFontSize = 24,
    double customTBPadding = 0,
    TextAlign customTextAlign = TextAlign.center,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 20),
    padding: EdgeInsets.symmetric(vertical: customTBPadding),
    child: SelectableText(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: customFontSize
      ),
      textAlign: customTextAlign
    ),
  );
}

Container sectionSubTitle(
  String text, {
    double customFontSize = 20,
    double customTBPadding = 3,
    TextAlign customTextAlign = TextAlign.start,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: customTBPadding),
    child: SelectableText(
      text,
      style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: customFontSize,
      decoration: TextDecoration.underline,
      ),
      textAlign: customTextAlign
    ),
  );
}

Container bodyText(
  String text, {
    double customFontSize = 15,
    TextAlign customTextAlign = TextAlign.start,
    double customTBPadding = 5,
    bool needsBold = false
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: customTBPadding),
    child: SelectableText(
      text,
      style: TextStyle(
        fontWeight: (needsBold) ? FontWeight.w500 : FontWeight.w400,
        fontSize: customFontSize
      ),
      textAlign: customTextAlign,
    ),
  );
}

Padding stepTitle({required IconData icon, required String text}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 5),
    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(icon, size: 25),
      SizedBox(width: 5),
      Flexible(child: bodyText(text))
    ]),
  );
}

Padding listWrite(String text, {bool needsLeftPadding = false}) {
  return Padding(
    padding: EdgeInsets.only(top: 2, bottom: 2, left: (needsLeftPadding) ? 17 : 0),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SelectableText((needsLeftPadding) ? '− ' : '・'),
      Flexible(child: SelectableText(text))
    ]),
  );
}

SizedBox stepPadding() => SizedBox(height: 6);
SizedBox subtitlePadding() => SizedBox(height: 8);


List<Map<String, String>> chatPromptTableData = [
  {
    'プロンプトの状況': 'ユーザーが情報を探している',
    '応答': '検索結果を表示',
    '例': 'ー'
  },
  {
    'プロンプトの状況': 'ユーザーが単なる会話をしていると判断された',
    '応答': 'わからないと伝える',
    '例': '「すごい！」'
  },
  {
    'プロンプトの状況': '不適切な言葉が含まれている場合',
    '応答': '警告',
    '例': 'ー'
  },
  {
    'プロンプトの状況': '質問意図がないと判断された場合',
    '応答': '警告',
    '例': 'プロンプトの文字数が1文字'
  },
  {
    'プロンプトの状況': 'ユーザーが会話を終了したいと判断された場合',
    '応答': 'チャット終了を提案',
    '例': '「さようなら」'
  },
  {
    'プロンプトの状況': 'ユーザーが暇そうな場合',
    '応答': 'ミニゲームを提案',
    '例': '「暇です」'
  },
];

