import 'package:flutter/material.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_dx/demo_components/demo_caution.dart';
import 'package:office_dx/demo_components/demo_uploading_dialog.dart';
import 'package:office_dx/demo_functions/demo_function_firebase_upload_qa_update.dart.dart';
import 'package:office_dx/pages/admin_page/manage_qa/sub_components/subcomp_qa_dialog.dart';
import 'package:office_dx/pages/admin_page/manage_qa/sub_components/subcomp_qa_tile_explain.dart';
import 'package:office_dx/pages/admin_page/admin_page_components/comp_add_button.dart';
import 'package:office_dx/functions/function_variable.dart';
import 'package:office_dx/components/reload_icon_button_grey.dart';
import 'package:office_dx/functions/function_firebase_initialize.dart';
import 'package:office_dx/functions/function_firebase_get_allqalist.dart';
import 'package:office_dx/functions/function_firebase_upload_qa_delete.dart';
import 'package:office_dx/components/loading_alertdialog.dart';



class ManageQaPage extends StatefulWidget {
  const ManageQaPage({super.key});

  @override
  State<ManageQaPage> createState() => ManageQaPageState();
}

class ManageQaPageState extends State<ManageQaPage> {
  List<Map<String, dynamic>> allQaList = [];              // Cloud Firestoreから持ってきたQ&A情報を格納する変数
  Map<String, Map<String, dynamic>> categoryMap = {};     // Cloud Firestoreから持ってきたQ&Aのカテゴリを格納する変数
  bool isLoading = false;
  bool isUploading = false;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  // =================================================  Firebase読み込み処理 =================================================
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized(); // Flutterのウィジェットバインディングを初期化
    initializeFirebaseReferences(); // Firebase初期処理の開始
  }

  // ------------------------------------  Firebase初期処理 ------------------------------------
  void initializeFirebaseReferences() async {
    await functionFirebaseInitialize(); // Firebaseの初期化

    funtionFirebaseGetAllqalist(
      firestoreInstance: firestoreInstance,
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
          isLoading = recvIsLoading;
        });
      }
    );
  }
  // ------------------------------------------------------------------------------------------
  // =======================================================================================================================

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double maxWidth = (screenWidth < 800) ? 350 : 500;      // スマホの幅を800px未満・デスクトップはそれ以上と定義
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('管理 - Q&A', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xff568bf7),
          actions: [IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white, size: 28)
          )],
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // =======================================================  ヘッダー ======================================================
                  SizedBox(
                    width: maxWidth+200,
                    child: PageTitle(
                      title: 'Q&A一覧',
                      customColor: Color(0xFF0267B7),
                      leftZone: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 37, child: sumcompQaTileExplain()),
                          SizedBox(
                            width: 37,
                            child: reloadIconButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await Future.delayed(Duration(milliseconds: 600));
                                initializeFirebaseReferences();     // データの再読み込み
                              }
                            ),
                          )
                        ],
                      ),
                      // -------------------------------- 追加ボタン/追加処理 --------------------------------
                      rightZone: Container(
                        margin: EdgeInsets.only(top:3, bottom: 2),
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          style: compAddButtonStyle,
                          child: compAddButtonChild,
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return GestureDetector(
                                      onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
                                      child: SubcompQaDialog(
                                        firestoreInstance: firestoreInstance,
                                        isEdit: false,
                                        oldQuestionText: '',
                                        oldAnswerText: '',
                                        oldSelectedCategoryDocId: '',
                                        categoryMap: categoryMap,
                                        argCompleteUpload: (bool recvBool) {
                                          if(recvBool) {
                                            initializeFirebaseReferences();
                                          }
                                        },
                                        targetDocId: ''
                                      ),
                                    );
                                  }
                                );
                              }
                            );
                          }
                        ),
                      ),
                      // ----------------------------------------------------------------------------------
                    ),
                  ),
                  // =======================================================================================================================
                  SizedBox(height: 10),

                  // ===================================================== QA一覧表示 =======================================================
                  Container(
                    constraints: BoxConstraints(maxHeight: 650),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: (isLoading)
                          ? loadingAlertDialog()    // 読み込み中だったらクルクルマークを表示
                          : (allQaList.isEmpty)
                            ? Padding(
                              padding: const EdgeInsets.only(top: 40, bottom: 40),
                              child: Text('何も登録されていません', style: TextStyle(fontSize: 21)),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(allQaList.length, (index) {
                              return SizedBox(
                                width: maxWidth+50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      // ------------------------------------ 更新処理 -------------------------------------
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext dialogContext) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return GestureDetector(
                                                  onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
                                                  child: SubcompQaDialog(
                                                    firestoreInstance: firestoreInstance,
                                                    isEdit: true,
                                                    oldQuestionText: allQaList[index]['question'],
                                                    oldAnswerText: allQaList[index]['answer'],
                                                    oldSelectedCategoryDocId: allQaList[index]['categoryDocId'],
                                                    categoryMap: categoryMap,
                                                    argCompleteUpload: (bool recvBool) {
                                                      if(recvBool) {
                                                        initializeFirebaseReferences();
                                                      }
                                                    },
                                                    targetDocId: allQaList[index]['qaDocId'],
                                                  ),
                                                );
                                              }
                                            );
                                          }
                                        );
                                      },
                                      // ----------------------------------------------------------------------------------
                                      style: TextButton.styleFrom(
                                        fixedSize: Size(double.infinity, 120),
                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff50aad8),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                                  child: Text(categoryMap[allQaList[index]['categoryDocId']]?['categoryName'], style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  allQaList[index]['question'],
                                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  allQaList[index]['answer'],
                                                  style: TextStyle(color: Color(0xff222222), fontSize: 11, fontWeight: FontWeight.w500),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 2),
                                                SizedBox(
                                                  height: 14,
                                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Flexible(
                                                        flex: 11,
                                                        child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                                                          Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.schedule_outlined, size: 13, color: introPdfColor)),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            formatDateAndTime(allQaList[index]['createdAt']),
                                                            style: TextStyle(color: introPdfColor, fontSize: 11, fontWeight: FontWeight.w500),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ]),
                                                      ),

                                                      (allQaList[index]['updatedAt'] == notUpdatedAt)    // 更新がある場合は更新日時も表示
                                                      ? SizedBox.shrink()
                                                      : Flexible(
                                                        flex: 11,
                                                        child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                                                            SizedBox(width: 15),
                                                            Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.update_outlined, size: 14, color: introPdfColor)),
                                                            // Text('更新日', style: TextStyle(color: introPdfColor, fontSize: 11, fontWeight: FontWeight.w500)),
                                                            SizedBox(width: 3),
                                                            Text(
                                                              formatDateAndTime(allQaList[index]['updatedAt']),
                                                              style: TextStyle(color: introPdfColor, fontSize: 12, fontWeight: FontWeight.w500),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ]),
                                                      ),
                                                      Flexible(flex: 1, child: SizedBox(width: 4))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // ------------------------------------ 削除ボタン -------------------------------------
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    contentPadding: const EdgeInsets.fromLTRB(26, 10, 26, 10),
                                                    title: Text('確認'),
                                                    content: SizedBox(
                                                      width: 300,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xfffce6ef),
                                                              borderRadius: BorderRadius.circular(6)
                                                            ),
                                                            child: Column(
                                                              children: const [
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top: 2),
                                                                      child: Icon(Icons.report_problem_outlined, size: 17),
                                                                    ),
                                                                    SizedBox(width: 3),
                                                                    Flexible(child: Text('注意', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 8),
                                                                  child: Text(
                                                                    '削除処理を実行すると完全にサーバー上から削除されるため、その処理を元に戻すことはできません。',
                                                                    style: TextStyle(fontSize: 12),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          // ---------------- デモ用警告 ----------------
                                                          DemoCaution(
                                                            customIconSize: 18,
                                                            customTextSize: 13,
                                                            customLRPadding: 10
                                                          ),
                                                          SizedBox(height: 10),
                                                          // -------------------------------------------
                                                          Text('本当に削除しますか？\n各Q&A部分をタップすると、ファイルを編集することもできます。'),
                                                          SizedBox(height: 3),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("OK"),
                                                          onPressed: () async{
                                                            bool isDeleting = true;
                                                      
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                // return uploadingDialog(type: 3);
                                                                return demoUploadingDialog(type: 3);    // (デモ用)アップロードダイアログに変更
                                                              },
                                                            );
                                                            /*
                                                            await funtionFirebaseUploadQaDelete(
                                                              firestoreInstance: firestoreInstance,
                                                              targetDocId: allQaList[index]['qaDocId'],
                                                              argIsDeletingCallback: (bool recvBool) {
                                                                setState(() {
                                                                  isDeleting = recvBool;
                                                                });
                                                              }
                                                            );
                                                            */
                                                            // (デモ用) Firebaseの内容を削除する処理を行わず、アップロード中の表示だけを行う
                                                            await demoFuntionFirebaseUploadQaUpload(
                                                              argIsUploading: (bool recvBool) {
                                                                setState(() {
                                                                  isDeleting = recvBool;
                                                                });
                                                              },
                                                            );
                                                      
                                                            if (!isDeleting) {
                                                              if (mounted){
                                                                Navigator.of(context).pop();
                                                              }
                                                            }
                                                      
                                                            Navigator.of(context).pop();
                                                            initializeFirebaseReferences();
                                                          },
                                                      ),
                                                      TextButton(
                                                        child: Text("キャンセル", style: TextStyle(color: Colors.red)),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                }
                                              );
                                            },
                                            icon: Icon(Icons.delete, color: Colors.black)
                                          )
                                          // ----------------------------------------------------------------------------------
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Divider(
                                        thickness: 0.8, color: Theme.of(context).colorScheme.secondary
                                      )
                                    )
                                  ],
                                ),
                              );
                            }),
                          )
                        )
                      ),
                    ),
                  ),
                  // ============================================================================================================================
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}





// ============= 各部分のスタイルを以下で一括指定 =============
final Color introPdfColor = Color(0xff777777);


