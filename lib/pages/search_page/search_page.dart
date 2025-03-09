import 'package:flutter/material.dart';
import 'package:office_dx/components/apply_button.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_dx/functions/function_firebase_initialize.dart';
import 'package:office_dx/functions/function_show_firebase_pdf.dart';
import 'package:office_dx/functions/function_firebase_get_alldoclist.dart';
import 'package:office_dx/functions/function_firebase_get_allqalist.dart';
import 'package:office_dx/functions/function_variable.dart';
import 'package:office_dx/components/qna_tile.dart';
import 'package:office_dx/pages/3_bottom_tabs/qna_detail_page.dart';
import 'package:office_dx/functions/function_search_doclist.dart';
import 'package:office_dx/functions/function_search_qalist.dart';
import 'package:office_dx/components/loading_alertdialog.dart';
import 'package:office_dx/functions/function_firebase_get_sensitivelist.dart';
import 'package:office_dx/functions/prompt/function_check_prompt.dart';






class SearchPage extends StatefulWidget {
  const SearchPage({super.key,
    required this.requestSearchWord
  });

  final String requestSearchWord;

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  // -------------------------------------------------- 変数 -------------------------------------------------
  bool _isFirebaseInitialized = false;
  bool isLoadingDoc = false;
  bool isLoadingQa = false;
  late Reference storageRef;
  late Reference defaultPdfPathReference;     // defaultPdfへの参照のパス
  late Reference uploadedPdfPathReference;    // uploadPdfへの参照のパス
  late ListResult defaultPdfListAll;          // defaultPdfの情報を格納するリスト
  late ListResult uploadedPdfListAll;         // uploadedPdfの情報を格納するリスト
  List<Map<String, dynamic>> allDocList = [];     // Cloud Firestoreから持ってきたファイル情報を格納する変数
  List<Map<String, dynamic>> allQaList = [];     // Cloud Firestoreから持ってきたQ&A情報を格納する変数
  Map<String, Map<String, dynamic>> categoryMap = {};     // Cloud Firestoreから持ってきたQ&Aのカテゴリを格納する変数
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> filteredDocList = [];    // 検索ワードに合致したQ&A情報を格納する変数
  List<Map<String, dynamic>> filteredQaList = [];     // 検索ワードに合致したファイル情報を格納する変数
  List<String> sensitiveWordsList = [];           // 不適切なワードを取得し格納するリスト
  bool isSensitive = false;
  Color searchResultBarDeepColor = Color(0xffe6f5ff);
  Color searchResultBarLightColor = Color(0xff058feb);
  // ---------------------------------------------------------------------------------------------------------

  // ---------------------------------------------  Firebase 処理 ---------------------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _initialize();
  }

  Future<void> _initialize() async {
    // checkSensitive の処理を非同期で待つ
    bool isSensitiveLocal = await checkSensitive(searchWord: widget.requestSearchWord);
    isSensitive = isSensitiveLocal;

    if (!isSensitiveLocal) {
      // Firebase の初期化
      await initializeFirebaseApplication();
      await initializeFirebaseQa();
    }

    // 状態の更新
    setState(() {
      _isFirebaseInitialized = true;
      // searchResultBarDeepColor = (isSensitive) ? Color(0xfffaeaee) : Color(0xffe6f5ff);
      // searchResultBarLightColor = (isSensitive) ? Color(0xffff577e) : Color(0xff058feb);
    });
  }

  // - - - - - - - - -  不適切ワードが含まれていないかチェック - - - - - - - - -
  Future<dynamic> checkSensitive({
    required String searchWord,
  }) async {
    await functionFirebaseInitialize();

    await funtionFirebaseGetSensitivelist(
      firestoreInstance: firestore,
      argUpdateSensitivelist: (List<String> recvList) {
        setState(() {
          sensitiveWordsList = recvList;
        });
      }
    );

    String promptKind = functionCheckPrompt(promptText: searchWord, sensitiveWordsList: sensitiveWordsList);

    if (promptKind == 'sensitive') {
      debugPrint('✅ 検索前処理完了：不適切なワード含む');
      return true;
    } else {
      debugPrint('✅ 検索前処理完了：不適切なワード含まない');
    }

    return false;
  }
  // - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - -

  Future<void> initializeFirebaseApplication() async {
    await functionFirebaseInitialize();

    // ↓ Firebase Storageのインスタンスを取得し、ストレージのルートリファレンスをstorageRefに代入
    storageRef = FirebaseStorage.instance.ref();
    // ↓ Firebaseのdefault_pdfディレクトリに対する子リファレンスを作成し、defaultPdfPathReferenceに代入
    defaultPdfPathReference = storageRef.child("default_pdf");
    uploadedPdfPathReference = storageRef.child("uploaded_pdf");

    funtionFirebaseGetAlldoclist(
      firestoreInstance: firestore,
      argUpdateIsLoading: (recvBool) {
        setState(() {
          isLoadingDoc = recvBool;
        });
      },
      argUpdateAllDocList: (recvList) {
        setState(() {
          allDocList = recvList;
        });
      },
      argUpdateIsUploading: (_) {}
    );

    debugPrint('✅allDocListをCloud Firestoreから持ってくるのに成功');
  }

  Future<void> initializeFirebaseQa() async {
    await functionFirebaseInitialize();

    funtionFirebaseGetAllqalist(
      firestoreInstance: firestore,
      argUpdateAllQaList: (recvQaList) {
        setState(() {
          allQaList = recvQaList;
        });
      },
      argUpdateCategoryMap: (recvCategoryMap) {
        setState(() {
          categoryMap = recvCategoryMap;
        });
      },
      argUpdateIsLoading: (recvIsLoading) {
        setState(() {
          isLoadingQa = recvIsLoading;
        });
        _conductSearch(
          allDocList: allDocList,
          allQaList: allQaList,
          searchWord: widget.requestSearchWord,
          sensitiveWordsList: sensitiveWordsList
        );
      },
    );

    debugPrint('✅allQaListをCloud Firestoreから持ってくるのに成功');
  }
  // ---------------------------------------------------------------------------------------------------------




  // ------------------------------------------------  検索命令 -----------------------------------------------
  void _conductSearch({
    required List<Map<String, dynamic>> allDocList,
    required List<Map<String, dynamic>> allQaList,
    required List<String> sensitiveWordsList,
    required String searchWord
  }) {
    // 検索を実行
    List<Map<String, dynamic>> keepDocList = searchQaList(allQaList: allQaList, searchWord: searchWord);
    setState(() {
      filteredQaList = keepDocList;
    });
    debugPrint(filteredQaList.toString());

    List<Map<String, dynamic>> keepQaList = searchDocList(allDocList: allDocList, searchWord: searchWord);
    setState(() {
      filteredDocList = keepQaList;
    });
    debugPrint(filteredDocList.toString());

    debugPrint('✅ 検索処理完了');
  }
  // ---------------------------------------------------------------------------------------------------------






  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double maxWidth = (screenWidth < 800) ? 350 : 500;      // スマホの幅を800px未満/デスクトップはそれ以上と定義
    searchResultBarLightColor = (isSensitive) ? Color(0xfffaeaee) : Color(0xffe6f5ff);
    searchResultBarDeepColor = (isSensitive) ? Color(0xffff577e) : Color(0xff058feb);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('検索', style: TextStyle(color: Colors.white)),
        actions: [IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, color: Colors.white)
        )],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          setState(() {
            isLoadingDoc = true;
            isLoadingQa = true;
          });
          await Future.delayed(Duration(milliseconds: 600));
          initializeFirebaseApplication();
          initializeFirebaseQa();     // データの再読み込み
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // ==================================== 「XXX」の検索結果バー ====================================
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: searchResultBarLightColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(Icons.search, color: searchResultBarDeepColor, size: 26),
                      ),
                      SizedBox(width: 6),
                      Text('「', style: TextStyle(color: searchResultBarDeepColor, fontSize: 22)),
                      Flexible(
                        child: Text(
                          (isSensitive) ? '*'*(widget.requestSearchWord.length) : widget.requestSearchWord,
                          style: TextStyle(color: searchResultBarDeepColor, fontSize: 22), maxLines: 1, overflow: TextOverflow.ellipsis)
                        ),
                      Text('」の検索結果', style: TextStyle(color: searchResultBarDeepColor, fontSize: 22))
                    ],
                  ),
                ),
                // ==============================================================================================
                (isSensitive)
                  ? Container(
                    margin: const EdgeInsets.only(top: 60),
                    width: maxWidth * 0.8,
                    child: Column(
                      children: [
                        Icon(Icons.error_outline_outlined, size: 45, color: Color(0xff666666)),
                        SizedBox(height: 10),
                        Text(
                          '不適切なワードが含まれるため${maxWidth == 500 ? '' : '\n'}検索を実行できません',
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ]
                    ),
                  )
                  : Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    constraints: BoxConstraints(
                      minHeight: 800,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        // ======================================= 検索結果（書類） =======================================
                        Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Column(
                            children: [
                              // ------------------------ サブタイトル ------------------------
                              PageTitle(
                                title: '書類',
                                customColor: Theme.of(context).colorScheme.primary,
                              ),
                              Divider(
                                thickness: 2.3,
                                color: Theme.of(context).colorScheme.secondary,
                                height: 0
                              ),
                              // ------------------------------------------------------------
                              SizedBox(height: 10),
                              // -------------------------- 結果表示 --------------------------
                              (isLoadingDoc)
                                // 読み込み中だったら、クルクルマークを表示
                                ? SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 10),
                                      SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
                                      SizedBox(height: 30),
                                      Text('検索中...', style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                )
                                : (filteredDocList.isEmpty)
                                  ? Padding(
                                    padding: const EdgeInsets.only(top: 40, bottom: 40),
                                    child: Text('該当なし', style: TextStyle(fontSize: 21)),
                                  )
                                  : Container(
                                    constraints: BoxConstraints(maxWidth: maxWidth-50),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(filteredDocList.length, (index) {
                                        return ApplyButton(
                                          needLRPadding: false,
                                          name: filteredDocList[index]['docName'],
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  content: loadingAlertDialog(),
                                                );
                                              },
                                            );

                                            await functionShowFirebasePdf(
                                              isFirebaseInitialized: _isFirebaseInitialized,
                                              context: context,
                                              fileName:  filteredDocList[index]['fileName'],
                                              fileUrl: filteredDocList[index]['fileUrl'],
                                              argIsLoadingPdfCallback: (bool recvBool) {
                                                if (!recvBool) {
                                                  Navigator.of(context).pop();
                                                }
                                              }
                                            );
                                          }
                                        );
                                      }
                                    ),
                                                            ),
                                  ),
                              // ------------------------------------------------------------
                            ],
                          ),
                        ),
                        // ==============================================================================================
                  
                  
                        const SizedBox(height: 40),
                  
                  
                        // ======================================= 検索結果（Q&A） =======================================
                        Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Column(
                            children: [
                              // ------------------------ サブタイトル ------------------------
                              PageTitle(
                                title: 'Q&A',
                                customColor: Theme.of(context).colorScheme.primary,
                              ),
                              Divider(
                                thickness: 2.3,
                                color: Theme.of(context).colorScheme.secondary,
                                height: 0
                              ),
                              // ------------------------------------------------------------
                              SizedBox(height: 10),
                              // -------------------------- 結果表示 --------------------------
                              (isLoadingQa)
                                // 読み込み中だったら、クルクルマークを表示
                                ? loadingAlertDialog(
                                  customMessage: '検索中...'
                                )
                                : (filteredQaList.isEmpty)
                                  ? Padding(
                                    padding: const EdgeInsets.only(top: 40, bottom: 40),
                                    child: Text('該当なし', style: TextStyle(fontSize: 21)),
                                  )
                                  : Container(
                                    constraints: BoxConstraints(maxWidth: maxWidth),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(filteredQaList.length, (index) {
                                        return QNATile(
                                          createdAt: formatDateAndTime(filteredQaList[index]['createdAt']),
                                          updatedAt: formatDateAndTime(filteredQaList[index]['updatedAt']),
                                          question: filteredQaList[index]['question'],
                                          categoryName: categoryMap[filteredQaList[index]['categoryDocId']]?['categoryName'],
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => QaDetailPage(
                                                createdAt: formatDateAndTime(filteredQaList[index]['createdAt']),
                                                question: filteredQaList[index]['question'],
                                                answer: filteredQaList[index]['answer'],
                                                categoryName: categoryMap[filteredQaList[index]['categoryDocId']]?['categoryName'],
                                                updatedAt: formatDateAndTime(filteredQaList[index]['updatedAt']),
                                                displayLoadMark: true
                                              ),
                                              fullscreenDialog: true,
                                            ));
                                          },
                                        );
                                      })
                                    ),
                                  )
                              // ------------------------------------------------------------
                            ],
                          ),
                        ),
                        // ==============================================================================================
                  
                  
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
