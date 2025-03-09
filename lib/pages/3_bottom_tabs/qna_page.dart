import 'package:flutter/material.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:office_dx/components/qna_tile.dart';
import 'package:office_dx/pages/3_bottom_tabs/qna_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_dx/functions/function_firebase_initialize.dart';
import 'package:office_dx/functions/function_firebase_get_allqalist.dart';
import 'package:office_dx/functions/function_variable.dart';
import 'package:office_dx/components/loading_alertdialog.dart';
import 'package:office_dx/components/qa_filter_button.dart';
import 'package:office_dx/functions/function_qa_filter.dart';
import 'package:office_dx/components/reload_icon_button_grey.dart';




double maxWidth = 550;

class Question {
  final String date;
  final String question;
  final String answer;

  Question({required this.date, required this.question, required this.answer});
}

class QnAPage extends StatefulWidget {
  const QnAPage({super.key});

  @override
  QNATilePageState createState() => QNATilePageState();
}

class QNATilePageState extends State<QnAPage> {
  List<Map<String, dynamic>> allQaList = [];     // Cloud Firestoreから持ってきたQ&A情報を格納する変数
  Map<String, Map<String, dynamic>> categoryMap = {};     // Cloud Firestoreから持ってきたQ&Aのカテゴリを格納する変数
  bool isLoading = false;
  bool isUploading = false;
  List<String> searchCondList = []; // 検索対象のカテゴリのみを格納するリスト
  List<Map<String, dynamic>> filteredQaList = [];
  bool isFiltering = false;
  bool isFiltered = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // =========================================  Firebase初期処理 =============================================
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initializeFirebaseReferences();
    allCopyToFilterd();
  }

  void initializeFirebaseReferences() async {
    await functionFirebaseInitialize();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    funtionFirebaseGetAllqalist(
      firestoreInstance: firestore,
      argUpdateAllQaList: (recvQaList) {
        setState(() {
          allQaList = recvQaList;
          allCopyToFilterd();
        });
      },
      argUpdateCategoryMap: (recvCategoryMap) {
        setState(() {
          categoryMap = recvCategoryMap;
        });
      },
      argUpdateIsLoading: (recvIsLoading) {
        setState(() {
          isLoading = recvIsLoading;
        });
      },
    );
  }

  void allCopyToFilterd() {
    setState(() {
      filteredQaList = allQaList;
    });
    debugPrint('filteredQaListは、$filteredQaList', wrapWidth: 10000);
  }
  // ==============================================================================================================

  // -------------------------------- ページ番号実装時に使用予定 --------------------------------
  // int _currentPage = 1;

  // final List<Question> _qnaData = [];

  // final int _itemsPerPage = 10;

  // List<Question> _getCurrentPageData() {
  //   final startIndex = (_currentPage - 1) * _itemsPerPage;
  //   final endIndex = startIndex + _itemsPerPage;
  //   return _qnaData.sublist(
  //       startIndex, endIndex > _qnaData.length ? _qnaData.length : endIndex);
  // }

  // void _changePage(int pageNumber) {
  //   setState(() {
  //     _currentPage = pageNumber;
  //   });
  // }
  // ---------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 22, 12, 0),
      child: Center(
        child: Container(
          color: Colors.white,
          constraints: BoxConstraints(
            // minWidth: 100, // 最小幅
            minHeight: 800,
          ),
          child: Column(
            children: [
              // ------------------------------- ページタイトル --------------------------------
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth+100),
                child: PageTitle(
                  title: 'Q&A',
                  customColor: Color(0xFF0267B7),
                  leftZone: Row(
                    children: [
                      // - - - - - - - - - - - - フィルターボタン - - - - - - - - - - - -
                      QaFilterButton(
                        categoryMap: categoryMap,
                        searchCondList: searchCondList,
                        argSearchCondList: (List<String> recvNewList) {
                          setState(() {
                            searchCondList = recvNewList;
                          });
                        },
                        argComplete: (bool recvComplete) {
                          if (recvComplete) {
                            functionQaFilter(
                              allQaList: allQaList,
                              searchCondList: searchCondList,
                              argFilteredQaList: (List<Map<String, dynamic>> recvFilteredQaList) {
                                setState(() {
                                  filteredQaList = recvFilteredQaList;
                                });
                              },
                              argIsFiltering: (bool recvIsFiltering) {
                                setState(() {
                                  isFiltering = recvIsFiltering;
                                });
                              }
                            );
                          }
                        }
                      ),
                      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      // - - - - - - - - - - - - 再読み込みボタン - - - - - - - - - - - -
                      SizedBox(
                        width: 37,
                        child: reloadIconButton(
                          customIconSize: 22,
                          customTopPadding: 0,
                          customColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            if (searchCondList.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text('確認'),
                                    content: Text('リロードすると検索条件がリセットされます。\nよろしいですか？'),
                                    actions: [
                                      TextButton(
                                        child: Text("キャンセル", style: TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            searchCondList.clear();
                                            isLoading = true;
                                          });
                                          await Future.delayed(Duration(milliseconds: 600));
                                          initializeFirebaseReferences();     // データの再読み込み
                                        },
                                      ),
                                    ],
                                  );
                                }
                              );
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              await Future.delayed(Duration(milliseconds: 600));
                              initializeFirebaseReferences();     // データの再読み込み
                            }
                
                          }
                        ),
                      )
                      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    ],
                  )
                ),
              ),
              // -------------------------------------------------------------------------------
              const SizedBox(height: 5),
              (isLoading || isFiltering)
                // ------------------- 読み込み中だったら、クルクルマークを表示 -----------------------
                ? loadingAlertDialog()
                // -----------------------------------------------------------------------------
                  : (filteredQaList.isEmpty)
                    ? (searchCondList.isEmpty)
                      // ------------------- Q&A未登録の時 --------------------
                      ? Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 40),
                        child: Text('何も登録されていません', style: TextStyle(fontSize: 21)),
                      )
                      // -----------------------------------------------------
                      // ----------------- 条件に合うQ&Aがない時 ----------------
                      : Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 40),
                        child: Text('条件に合うQ&Aはありません', style: TextStyle(fontSize: 21)),
                      )
                      // -----------------------------------------------------
                    : Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 2,
                        // ------------------- Q&A表示 -------------------
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(filteredQaList.length, (index) {
                              return Container(
                                constraints: BoxConstraints(maxWidth: maxWidth),
                                child: QNATile(
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
                                ),
                              );
                            })
                          ),
                        ),
                        // ----------------------------------------------
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
