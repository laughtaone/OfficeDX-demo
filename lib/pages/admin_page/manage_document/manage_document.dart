import 'package:flutter/material.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_dx/components/uploading_dialog.dart';
import 'package:office_dx/demo_components/demo_caution.dart';
import 'package:office_dx/demo_components/demo_uploading_dialog.dart';
import 'package:office_dx/demo_functions/demo_function_firebase_upload_doc_update.dart';
import 'package:office_dx/pages/admin_page/admin_page_components/comp_add_button.dart';
import 'package:office_dx/components/reload_icon_button_grey.dart';
import 'package:office_dx/functions/function_variable.dart';
import 'package:office_dx/pages/admin_page/manage_document/sub_components/subcomp_doc_tile_explain.dart';
import 'package:office_dx/functions/function_firebase_get_alldoclist.dart';
import 'package:office_dx/functions/function_firebase_initialize.dart';
import 'package:office_dx/functions/function_firebase_upload_doc_delete.dart';
import 'package:office_dx/components/loading_alertdialog.dart';
import 'package:office_dx/pages/admin_page/manage_document/sub_components/subcomp_document_dialog.dart';



double maxWidth = 350;


class ManageDocumentPage extends StatefulWidget {
  const ManageDocumentPage({super.key});

  @override
  State<ManageDocumentPage> createState() => ManageDocumentPageState();
}

class ManageDocumentPageState extends State<ManageDocumentPage> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseStorage storageInstance = FirebaseStorage.instance;
  List<Map<String, dynamic>> allDocList = [];     // Cloud Firestoreから持ってきたファイル情報を格納する変数
  bool isLoading = false;       // 読み込み中かどうか管理する変数
  bool isUploading = false;
  bool isFirstLoad = false;
  late Reference storageRef;
  late Reference pdfPathReference;
  late ListResult defaultPdfListAll;
  FilePickerResult? resultSelectedFile;
  // String _selectedFileName = '';
  // String _inputtedDocName = '';
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
  }

  // ------------------------------------  Firebase初期処理 ------------------------------------
  void initializeFirebaseReferences() async {
    await functionFirebaseInitialize(); // Firebaseの初期化

    // Firebase Storageの参照取得
    // Firebase Storageのインスタンスを取得し、ストレージのルートリファレンスをstorageRefに代入
    storageRef = FirebaseStorage.instance.ref();
    // Firebaseのdefault_pdfディレクトリに対する子リファレンスを作成し、pdfPathReferenceに代入
    pdfPathReference = storageRef.child("uploaded_pdf");

    // ディレクトリ内の全ファイルをリストアップ
    defaultPdfListAll = await pdfPathReference.listAll();

    setState(() {
      isFirstLoad = true;
      isLoading = true;
    });

    await funtionFirebaseGetAlldoclist(
      firestoreInstance: firestoreInstance,
      argUpdateAllDocList: (recvList) {
        setState(() {
          allDocList = recvList;
        });
      },
      argUpdateIsLoading: (recvIsLoading) {
        setState(() {
          isLoading = recvIsLoading;
        });
      },
      argUpdateIsUploading: (recvIsUploading) {
        setState(() {
          isUploading = recvIsUploading;
        });
      },
    );

    setState(() {
      isLoading = false;
      isUploading = false;
    });
  }
  // ------------------------------------------------------------------------------------------
  // ==============================================================================================================


  // =========================================== 選択したファイルをリセット ===========================================
  void resetResultSelectedFile() {
    setState(() {
      resultSelectedFile = null;
    });
  }
  // ==============================================================================================================



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('管理 - 掲載書類', style: TextStyle(color: Colors.white)),
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
                  SizedBox(
                    width: maxWidth+200,
                    child: PageTitle(
                      title: '掲載書類一覧',
                      customColor: Color(0xFF0267B7),
                      leftZone: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 37, child: sumcompDocTileExplain()),
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
                      rightZone: Container(
                        margin: EdgeInsets.only(top:3, bottom: 2),
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          style: compAddButtonStyle,
                          child: compAddButtonChild,
                          // ===================================================== 追加ボタン/追加処理 =====================================================
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return GestureDetector(
                                      onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
                                      child: SubcompDocumentDialog(
                                        firestoreInstance: firestoreInstance,
                                        storageInstance: storageInstance,
                                        isEdit: false,
                                        argCompleteUpload: (bool recvBool) {
                                          if (recvBool) {
                                            initializeFirebaseReferences();
                                          }
                                        },
                                        oldDocName: '',
                                        oldFileName: '',
                                        targetDocId: '',
                                        oldFileUrl: ''
                                      ),
                                    );
                                  }
                                );
                              }
                            );
                          },
                          // ============================================================================================================================
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // ======================================================= 書類一覧表示 =========================================================
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 50,
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: (!isFirstLoad)
                          ? SizedBox(
                              height: 160,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
                                  SizedBox(height: 30),
                                  Text('初期読み込みが未完了です\nしばらくそのままお待ちください', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                                ],
                              ),
                            )
                          : (isLoading)
                          // ------------------- 読み込み中だったら、クルクルマークを表示 -----------------------
                          ? loadingAlertDialog()
                          // ----------------------------------------------------------------------------
                          : (allDocList.isEmpty)
                            ? Padding(
                              padding: const EdgeInsets.only(top: 40, bottom: 40),
                              child: Text('何も登録されていません', style: TextStyle(fontSize: 21)),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(allDocList.length, (index) {
                              return SizedBox(
                                width: maxWidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      // -------------------------------------------- 登録情報を変更 --------------------------------------------
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext dialogContext) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return GestureDetector(
                                                  onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
                                                  child: SubcompDocumentDialog(
                                                    firestoreInstance: firestoreInstance,
                                                    storageInstance: storageInstance,
                                                    isEdit: true,
                                                    argCompleteUpload: (bool recvBool) {
                                                      if (recvBool) {
                                                        initializeFirebaseReferences();
                                                      }
                                                    },
                                                    oldDocName: allDocList[index]['docName'],
                                                    oldFileName: allDocList[index]['fileName'],
                                                    targetDocId: allDocList[index]['docId'],
                                                    oldFileUrl: allDocList[index]['fileUrl']
                                                  ),
                                                );
                                              }
                                            );
                                          }
                                        );
                                      },
                                      // -----------------------------------------------------------------------------------------------------------
                                      style: TextButton.styleFrom(
                                        fixedSize: Size(double.infinity, 70),
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
                                                SizedBox(height: 3),
                                                Text(
                                                  allDocList[index]['docName'],
                                                  style: TextStyle(fontSize: 22, color: Colors.black),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  allDocList[index]['fileName'],
                                                  style: TextStyle(color: introPdfColor, fontSize: 11, fontWeight: FontWeight.w500),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 14,
                                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Flexible(
                                                        flex: 11,
                                                        child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                                                          Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.schedule_outlined, size: 14, color: introPdfColor)),
                                                          // Text('作成日', style: TextStyle(color: introPdfColor, fontSize: 11, fontWeight: FontWeight.w500)),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            formatDateAndTime(allDocList[index]['createdAt']),
                                                            style: TextStyle(color: introPdfColor, fontSize: 12, fontWeight: FontWeight.w500),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ]),
                                                      ),

                                                      (allDocList[index].containsKey('updatedAt'))
                                                        ? (allDocList[index]['updatedAt'] == notUpdatedAt)    // 更新がある場合は更新日時も表示
                                                          ? SizedBox.shrink()
                                                          : Flexible(
                                                            flex: 11,
                                                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                                                                SizedBox(width: 15),
                                                                Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.update_outlined, size: 14, color: introPdfColor)),
                                                                // Text('更新日', style: TextStyle(color: introPdfColor, fontSize: 11, fontWeight: FontWeight.w500)),
                                                                SizedBox(width: 3),
                                                                Text(
                                                                  formatDateAndTime(allDocList[index]['updatedAt']),
                                                                  style: TextStyle(color: introPdfColor, fontSize: 12, fontWeight: FontWeight.w500),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ]),
                                                          )
                                                        : SizedBox.shrink(),
                                                      Flexible(flex: 1, child: SizedBox(width: 4))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // ---------------------------------------------- 削除ボタン ----------------------------------------------
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
                                                      width: 280,
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
                                                          Text('本当に削除しますか？\n各書類部分をタップすると、ファイルを編集することもできます。'),
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
                                                                return demoUploadingDialog(type: 3);  // (デモ用)アップロードダイアログに変更
                                                              },
                                                            );

                                                            /*
                                                            await functionFirebaseUploadDocDelete(
                                                              firestoreInstance: firestoreInstance,
                                                              storageInstance: storageInstance,
                                                              targetDocId: allDocList[index]['docId'],
                                                              targetFileUrl: allDocList[index]['fileUrl'],
                                                              argIsDeletingCallback: (bool recvBool) {
                                                                setState(() {
                                                                  isDeleting = recvBool;
                                                                });
                                                              }
                                                            );
                                                            */
                                                            // (デモ用) Firebaseの内容を削除する処理を行わず、アップロード中の表示だけを行う
                                                            await demoFunctionFirebaseUploadDocUpdate(
                                                              argIsUploadingCallback: (bool recvBool) {
                                                                setState(() {
                                                                  isDeleting = recvBool;
                                                                });
                                                              },
                                                              argResultSelectedFile: (_) {}
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
                                          // -----------------------------------------------------------------------------------------------------------
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

                  SizedBox(height: 45),
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
Padding subtitleLocalComp({required String recvText, bool mini = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      recvText,
      overflow: TextOverflow.clip,
      maxLines: 1,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: (!mini) ?19 :17)
    )
  );
}

Padding explainTextLocalComp(recvText) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      recvText,
      style: TextStyle(fontSize: 13, color: Color(0xff222222))
    ),
  );
}

final Color introPdfColor = Color(0xff777777);

Container changedDisplay({bool isDeepColor = false, String customText = '変更あり'}) {
  final Color mainColor = Color(0xff1E90FF);
  return Container(
    padding: const EdgeInsets.fromLTRB(6, 4, 6, 4) ,
    decoration: BoxDecoration(
      color: (!isDeepColor) ? Color(0xffE2F6FB) : Color(0xffD0E8F3),
      borderRadius: BorderRadiusDirectional.circular(10),
    ),
    child: Row(
      children: [
        Icon(Icons.check, color: mainColor, size: 16),
        SizedBox(width: 2),
        Text(customText, style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    )
  );
}
