import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:office_dx/components/search_result_buddle.dart';
import 'package:office_dx/functions/function_firebase_initialize.dart';
import 'package:office_dx/functions/function_search_similar_doc.dart';
import 'package:office_dx/functions/function_show_firebase_pdf.dart';
import 'package:office_dx/functions/function_firebase_get_alldoclist.dart';
import 'package:office_dx/functions/function_firebase_get_allqalist.dart';
import 'package:office_dx/functions/function_variable.dart';
import 'package:office_dx/functions/shared_preferences/function_get_settings.dart';
import 'package:office_dx/pages/game_page/game_top_page.dart';
import 'package:office_dx/pages/3_bottom_tabs/qna_detail_page.dart';
import 'package:office_dx/components/loading_alertdialog.dart';
import 'package:office_dx/components/message_buddle.dart';
import 'package:office_dx/functions/function_search_similar_qa.dart';
import 'package:office_dx/components/robot_icon.dart';
import 'package:office_dx/functions/function_firebase_get_sensitivelist.dart';
import 'package:office_dx/functions/prompt/function_check_prompt.dart';
import 'package:office_dx/pages/chat_page/info_chat_page.dart';




class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => SearchPageState();
}

class SearchPageState extends State<ChatPage> {
  // =============================================== 変数 ===================================================
  String chatText = '';
  final TextEditingController _chatTextController = TextEditingController();
  bool isFirst = true;
  List<Map<String, String>> chatHistoryList = [];
  bool isGeneratingAnswer = false;

  List<Map<String, dynamic>> allDocList = [];     // Cloud Firestoreから持ってきた書類情報を格納する変数
  List<Map<String, dynamic>> allQaList = [];     // Cloud Firestoreから持ってきたQ&A情報を格納する変数
  Map<String, Map<String, dynamic>> categoryMap = {};     // Cloud Firestoreから持ってきたQ&Aのカテゴリを格納する変数
  bool isLoading = false;
  bool isUploading = false;
  bool isFiltering = false;
  bool isFiltered = false;
  List<String> sensitiveWordsList = [];
  final GlobalKey _bottomAppBarKey = GlobalKey();         // BottomAooBarの高さ取得のために使用
  double bottomAppBarHeight = 0;                          // BottomAooBarの高さ
  final ScrollController _scrollController = ScrollController();
  bool isNotDisplayGreeting = false;
  bool isNotDisplayEndChat = false;
  bool isNotDisplayMiniGame = false;
  // =======================================================================================================


 // =========================================  Firebase初期処理 =============================================
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initializeFirebaseReferences();
    firstLoad();

    // ウィジェットがレンダリングされた後にBottomAppBarの高さを取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _bottomAppBarKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        bottomAppBarHeight = renderBox.size.height;
      });
    });
  }

  Future<void> initializeFirebaseReferences() async {
    await functionFirebaseInitialize();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await funtionFirebaseGetAllqalist(
      firestoreInstance: firestore,
      argUpdateAllQaList: (recvQaList) {
        setState(() {
          allQaList = recvQaList;
          debugPrint(allQaList.toString());
        });
      },
      argUpdateCategoryMap: (recvCategoryMap) {
        setState(() {
          categoryMap = recvCategoryMap;
          debugPrint(categoryMap.toString());
        });
      },
      argUpdateIsLoading: (_) {},
    );

    await funtionFirebaseGetAlldoclist(
      firestoreInstance: firestore,
      argUpdateIsLoading:  (_) {},
      argUpdateAllDocList: (recvDocList) {
        setState(() {
          allDocList = recvDocList;
        });
      },
      argUpdateIsUploading: (_) {},
    );

    await funtionFirebaseGetSensitivelist(
      firestoreInstance: firestore,
      argUpdateSensitivelist: (List<String> recvList) {
        setState(() {
          sensitiveWordsList = recvList;
        });
      }
    );
  }
  // =======================================================================================================

  // ==========================================  使用する関数類 ==============================================
  void firstLoad() async {
    await Future.delayed(Duration(milliseconds: 1600));
    bool keepIsNotDisplayGreeting = await loadIsNotDisplayGreeting() ?? false;
    bool keepIsNotDisplayEndChat = await loadIsNotDisplayEndChat() ?? false;
    bool keepIsNotDisplayMiniGame = await loadIsNotDisplayMiniGame() ?? false;
    setState(() {
      chatHistoryList.add({
        'who': 'bot',
        'message': 'こんにちは！\n\nお探しの内容を 単語単位 で教えてください！\n(例：クラブの入部申請について知りたい場合は「クラブ 入部申請」と入力してください)'
      });
      isNotDisplayGreeting = keepIsNotDisplayGreeting;
      isNotDisplayEndChat = keepIsNotDisplayEndChat;
      isNotDisplayMiniGame = keepIsNotDisplayMiniGame;
      isFirst = false;
    });
  }

  void sendMessage({required String message}) {
    setState(() {
      chatHistoryList.add({
        'who': 'user',
        'message': message,
      });

      debugPrint('🐬chatHistoryListは、${chatHistoryList.toString()}', wrapWidth: 10000000);


      isGeneratingAnswer = true;

      conductSearch(
        qaList: allQaList,
        docList: allDocList,
        searchText: message
      );

      _chatTextController.clear();
      message = '';
    });
  }

  void conductSearch({
    required String searchText,
    required List<Map<String, dynamic>> qaList,
    required List<Map<String, dynamic>> docList
  }) async {
    await Future.delayed(Duration(milliseconds: 1400));

    String promptKind = functionCheckPrompt(promptText: searchText, sensitiveWordsList: sensitiveWordsList);
    if (promptKind.contains('greeting') && isNotDisplayGreeting == false) {
      chatHistoryList.add({
        'who': 'bot',
        'message': '${promptKind.substring(9)}！\n\nお探しのものがあれば教えてください',
      });
    } else if (promptKind == 'sensitive') {
      chatHistoryList.add({
        'who': 'bot',
        'message': '不適切なワードが含まれているため、実行できません。\n\n入力テキストを確認・修正の上、再度試行してください。',
        'warning': 'true'
      });
    } else if (promptKind == 'indifferent') {
      chatHistoryList.add({
        'who': 'bot',
        'message': '有効なプロンプトでないと判断されました。\n\n入力テキストを確認・修正の上、再度試行してください。',
        'warning': 'true'
      });
    } else if (promptKind == 'idontknow') {
      chatHistoryList.add({
        'who': 'bot',
        'message': 'すみません、よくわかりません。\n\n入力テキストを確認・修正の上、再度試行してください。',
        'warning': 'true'
      });
    } else if (promptKind == 'goodbye' && isNotDisplayEndChat == false) {
      chatHistoryList.add({
        'who': 'bot',
        'message': 'チャット画面を閉じる場合は、下の閉じるボタンを押してください\n\nお探しのものがあれば教えてください！',
        'close': 'true'
      });
    } else if (promptKind == 'game' && isNotDisplayMiniGame == false) {
      chatHistoryList.add({
        'who': 'bot',
        'message': 'ミニゲームをプレイしますか？\n下のボタンから試してみてください！\n(授業中や勤務中のプレイはご遠慮ください)\n\nお探しのものがあれば教えてください！',
        'game': 'true'
      });
    } else {
      String resultConductSearchQa = findSimilarQa(
        searchText: searchText,
        qaList: qaList
      );

      String resultConductSearchDoc = findSimilarDoc(
        searchText: searchText,
        docList: docList
      );

      if (resultConductSearchQa != 'Not found' || resultConductSearchDoc != 'Not found') {
        chatHistoryList.add({
          'who': 'bot',
          'message': 'お探しの内容に近いものが見つかりました。\n\n他にお探しのものがあれば教えてください！',
          'qaResult': resultConductSearchQa,
          'docResult': resultConductSearchDoc
        });
      } else {
        chatHistoryList.add({
          'who': 'bot',
          'message': '見つかりませんでした。\n\n該当するものがないか可能性があります。別の言い方で再試行してみてください。\n\n他にお探しのものがあれば教えてください！',
        });
      }
    }


    setState(() {
      isGeneratingAnswer = false;
    });

    moveToBottom();
  }

  // qaDocIdに基づいてデータを取得する関数
  Map<String, dynamic>? getQaDetails(String qaDocId) {
    for (var qa in allQaList) {
      if (qa['qaDocId'] == qaDocId) {
        return {
          'question': qa['question'],
          'answer': qa['answer'],
          'createdAt': qa['createdAt'],
          'updatedAt': qa['updatedAt'],
          'categoryDocId': qa['categoryDocId']
        };
      }
    }
    return null; // 見つからなかった場合はnullを返す
  }
  Map<String, dynamic>? getDocDetails(String docId) {
    for (var doc in allDocList) {
      if (doc['docId'] == docId) {
        return {
          'docName': doc['docName'],
          'fileName': doc['fileName'],
          'fileUrl': doc['fileUrl'],
          'createdAt': doc['createdAt'],
          'updatedAt': doc['updatedAt']
        };
      }
    }
    return null; // 見つからなかった場合はnullを返す
  }

  // 画面最下部にスクロールする関数
  void moveToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.linear,
      );
    });
  }
  // =======================================================================================================




  @override
  Widget build(BuildContext context) {
    double bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double maxWidth = (screenWidth < 800) ? 400 : 500;      // スマホの幅を800px未満/デスクトップはそれ以上と定義
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff94B3E5),
          title: Text('チャット', style: TextStyle(color: Colors.white)),
          actions: [IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white)
          )],
          leading: infoChatPage()
        ),
        body: (isFirst)
        // ------------------------------ 初回 読み込みマーク表示 ------------------------------
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
              SizedBox(height: 20),
              Text('準備中...', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20))
            ],
          ),
        )
        // ---------------------------------------------------------------------------------
        : SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  constraints: BoxConstraints(
                    maxWidth: maxWidth + 200
                  ),
                  child: Column(
                      children: [
                        SizedBox(height: 25),
                        // ======================================= 検索結果（書類） =======================================
                        Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: (isFirst)
                            // ------------ 読み込み中だったら、クルクルマークを表示 -----------
                            ? Center(
                                child: SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
                              )
                            // ----------------------------------------------------------
                            : Container(
                                constraints: BoxConstraints(maxWidth: maxWidth + 50),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Column(
                                        children: List.generate(chatHistoryList.length, (index) {
                                          if (index >= chatHistoryList.length) return Container();      // エラー対策
                                          var chatItem = chatHistoryList[index];                        // インデックスを使う前にデータを取得
                                          return Container(
                                            padding: EdgeInsets.only(
                                              right: (chatItem['who'] == 'bot') ? 20 : 0,
                                              left: (chatItem['who'] == 'bot') ? 0 : 20,
                                            ),
                                            alignment: (chatItem['who'] == 'bot')
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                            child: (chatItem['who'] == 'bot')
                                              // --------------------- ボットのメッセージ --------------------
                                              ? Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                // - - - - - - - アイコン - - - - - - -
                                                RobotIcon(
                                                  argChatText: (String recvText) {
                                                    setState(() {
                                                      chatText = recvText;
                                                      _chatTextController.text = recvText;
                                                    });
                                                  },
                                                  warning: (chatItem['warning'] == 'true'),
                                                  isNotDisplayGreeting: isNotDisplayGreeting,
                                                  isNotDisplayEndChat: isNotDisplayEndChat,
                                                  isNotDisplayMiniGame: isNotDisplayMiniGame
                                                ),
                                                // - - - - - - - - - - - - - - - - - -
                                                SizedBox(width: 3),
                                                // - - - - - - - 吹き出し - - - - - - -
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // メッセージ部分
                                                      MessageBuddle(
                                                        isSender: false,
                                                        warning: (chatItem['warning'] == 'true'),
                                                        messageText: chatItem['message'] ?? '(不明なエラー)',
                                                      ),
                                                      // 検索結果部分(書類)
                                                      (chatItem['docResult'] != null && chatItem['docResult'] != 'Not found')
                                                        ? SearchResultBuddle(
                                                          kindText: '書類',
                                                          buttonIcon: Icons.description_outlined,
                                                          buttonText: getDocDetails(chatItem['docResult']!)?['docName'],
                                                          onPressed: () async {
                                                            bool isLoadingPdf = true; // PDFを読み込み中かどうかの真偽値
                                                            if (isLoadingPdf) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialog(
                                                                    backgroundColor: Colors.white,
                                                                    content: loadingAlertDialog(),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                            await functionShowFirebasePdf(
                                                              isFirebaseInitialized: true,
                                                              context: context,
                                                              fileName: getDocDetails(chatItem['docResult']!)?['fileName'],
                                                              fileUrl: getDocDetails(chatItem['docResult']!)?['fileUrl'],
                                                              argIsLoadingPdfCallback: (bool recvBool) {
                                                                if (!recvBool) {
                                                                  setState(() {
                                                                    isLoadingPdf = false;
                                                                    Navigator.pop(context);
                                                                  });
                                                                }
                                                              }
                                                            );
                                                          },
                                                        )
                                                        : Container(),
                                                      // 検索結果部分(Q&A)
                                                      (chatItem['qaResult'] != null && chatItem['qaResult'] != 'Not found')
                                                        ? SearchResultBuddle(
                                                          kindText: 'Q&A',
                                                          buttonIcon: Icons.contact_support_outlined,
                                                          buttonText: getQaDetails(chatItem['qaResult']!)?['question'],
                                                          onPressed: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => QaDetailPage(
                                                                question:  getQaDetails(chatItem['qaResult']!)?['question'],
                                                                answer: getQaDetails(chatItem['qaResult']!)?['answer'],
                                                                categoryName: categoryMap[getQaDetails(chatItem['qaResult']!)?['categoryDocId']]?['categoryName'],
                                                                createdAt: formatDateAndTime(getQaDetails(chatItem['qaResult']!)?['createdAt']),
                                                                updatedAt: formatDateAndTime(getQaDetails(chatItem['qaResult']!)?['updatedAt']),
                                                                displayLoadMark: true
                                                              ),
                                                              fullscreenDialog: true,
                                                            ));
                                                          }
                                                        )
                                                        : Container(),
                                                      // チャット画面閉じるボタン部分(閉じる意図があるプロンプトの場合のみ)
                                                      (chatItem['close'] != null && chatItem['close'] == 'true')
                                                        ? Center(
                                                          child: TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            style: TextButton.styleFrom(
                                                              backgroundColor: Color(0xffeaeefa),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16)
                                                              )
                                                            ),
                                                            child: Text('チャット画面を閉じる'),
                                                          ),
                                                        )
                                                        : (chatItem['game'] != null && chatItem['game'] == 'true')
                                                          // ゲーム画面遷移ボタン部分
                                                          ? Center(
                                                            child: TextButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => GameTopPage(),
                                                                    fullscreenDialog: true
                                                                  ),
                                                                );
                                                              },
                                                              style: TextButton.styleFrom(
                                                                backgroundColor: Color(0xffeaeefa),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(16)
                                                                )
                                                              ),
                                                              child: Text('🎮ミニゲームをする'),
                                                            ),
                                                          )
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                                // - - - - - - - - - - - - - - - - - -
                                              ])
                                              // ----------------------------------------------------------
                                              // --------------------- ユーザーのメッセージ -------------------
                                              : MessageBuddle(
                                                isSender: true,
                                                messageText: chatItem['message'] ?? '(不明なエラー)',
                                              ),
                                              // ----------------------------------------------------------
                                          );
                                        })
                                      ),
                                      // --------------- 回答生成中は読み込みマークを表示 ---------------
                                      (isGeneratingAnswer)
                                        ? Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 40),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 5, width: maxWidth * 0.4, child: LinearProgressIndicator()),
                                              SizedBox(height: 8),
                                              Text('回答生成中...', style: TextStyle(color: Theme.of(context).primaryColor))
                                            ],
                                          )
                                        )
                                        : Container()
                                      // ----------------------------------------------------------
                                    ],
                                  )
                                )
                              ),
                        ),
                        // ==============================================================================================

                        const SizedBox(height: 10),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          key: _bottomAppBarKey,
          color: Color(0xffEAF0FA),
          height: (bottomSpace == 0) ? null : bottomAppBarHeight + bottomSpace,
          child: SingleChildScrollView(
            child: Padding(
              // padding: EdgeInsets.only(bottom: bottomSpace),
              padding: EdgeInsets.only(bottom: 0),
              child: Center(
                child: Container(
                  width: (screenWidth < 800) ? double.infinity : double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: maxWidth
                  ),
                  child: Row(
                    children: [
                      // - - - - - - - - - 質問文入力フィールド  - - - - - - - - - -
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                          ),
                          child: TextField(
                            controller: _chatTextController,
                            onChanged: (newText) {
                              setState(() {
                                chatText = newText;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              hintText: 'お探しの内容を単語単位で入力',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (String value) {
                              debugPrint('chatTextは、$chatText');
                              debugPrint('isGeneratingAnswerは、$isGeneratingAnswer');
                              if (!(chatText.isEmpty || isGeneratingAnswer)) {
                                sendMessage(message: chatText);
                                _chatTextController.clear();
                                chatText = '';
                                moveToBottom();
                              }
                            }
                          )
                        ),
                      ),
                      // - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      SizedBox(width: 5),
                      // - - - - - - - - - - - 送信ボタン - - - - - - - - - - - - -
                      IconButton(
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(9),
                        ),
                        onPressed: (chatText.isEmpty || isGeneratingAnswer)
                          ? null
                          : () {
                            FocusScope.of(context).unfocus();
                            sendMessage(message: chatText);
                            _chatTextController.clear();
                            chatText = '';
                            moveToBottom();
                          },
                        icon: Icon(
                          Icons.send_rounded,
                          color: (chatText.isEmpty || isGeneratingAnswer)
                            ? Color(0xff7f7f7f).withValues(alpha: 0.3)
                            : Theme.of(context).primaryColor
                        )
                      )
                      // - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}









// ------ QAデータ(サンプル) ------
/*
final List<Map<String, dynamic>> qaData = [
  {
    'qaDocId': 'M1g0WmNm1hDacjzb2dFc',
    'question': '奨学金の申請期限はいつですか？◯◯◯奨学金に申し込みたいです。',
    'answer': '◯◯◯奨学金の申請期限は◯月◯日です。申請書類は学生課の窓口で配布していますので、早めに受け取って準備してください。',
    'createdAt': Timestamp(1728954699, 573000000),
    'updatedAt': Timestamp(1731284183, 94000000),
    'categoryDocId': 'sample_qa_category'
  },
  {
    'qaDocId': 'lKjTV2USIfWxZBK5tN04',
    'question': 'クラブに入部したいのですが、どのように入部申請をすればいいですか？',
    'answer': 'クラブ活動の入部申請は、XXXXXXXXXで受け付けています。日程はXXXXXXXXXXXXXXXXXで確認できますので、ぜひ参加してみてください。',
    'createdAt': Timestamp(1729238469, 437000000),
    'updatedAt': Timestamp(1729238104, 537000000),
    'categoryDocId': 'sample_qa_category_2'
  },
  {
    'qaDocId': 'ciKGtVGHnL1VJmaqL9D8',
    'question': '住所が変わりました。学校に何か申請する必要はありますか？',
    'answer': '住所が変わった場合、XXXXXXXXXXXXXXXXXXする必要があります。至急、XXXXXXXXXXXして下さい。',
    'createdAt': Timestamp(1729482490, 461632000),
    'updatedAt': Timestamp(1733489816, 829014000),
    'categoryDocId': 'sample_qa_category_3'
  }
];
*/
