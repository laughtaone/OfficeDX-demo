import 'package:flutter/material.dart';
import 'package:office_dx/components/apply_button.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_dx/functions/function_firebase_initialize.dart';
import 'package:office_dx/functions/function_show_firebase_pdf.dart';
import 'package:office_dx/functions/function_firebase_get_alldoclist.dart';
import 'package:office_dx/components/loading_alertdialog.dart';
import 'package:office_dx/components/reload_icon_button_grey.dart';



double maxWidth = 550;



class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => ApplicationPageState();
}

class ApplicationPageState extends State<ApplicationPage> {
  // ------------------------------------------------  Firebase 処理 -----------------------------------------------
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isFirebaseInitialized = false;
  late Reference storageRef;
  late Reference defaultPdfPathReference;     // defaultPdfへの参照のパス
  late Reference uploadedPdfPathReference;    // uploadPdfへの参照のパス
  late ListResult defaultPdfListAll;          // defaultPdfの情報を格納するリスト
  late ListResult uploadedPdfListAll;         // uploadedPdfの情報を格納するリスト
  List<Map<String, dynamic>> allDocList = [];     // Cloud Firestoreから持ってきたファイル情報を格納する変数
  bool isLoading = false;       // 読み込み中かどうか管理する変数


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initializeFirebaseReferences();
  }

  void initializeFirebaseReferences() async {
    await functionFirebaseInitialize();
    setState(() {
      _isFirebaseInitialized = true;
    });
    // ↓ Firebase Storageのインスタンスを取得し、ストレージのルートリファレンスをstorageRefに代入
    storageRef = FirebaseStorage.instance.ref();
    // ↓ Firebaseのdefault_pdfディレクトリに対する子リファレンスを作成し、defaultPdfPathReferenceに代入
    defaultPdfPathReference = storageRef.child("default_pdf");
    uploadedPdfPathReference = storageRef.child("uploaded_pdf");

    funtionFirebaseGetAlldoclist(
      firestoreInstance: firestore,
      argUpdateIsLoading: (recvBool) {
        setState(() {
          isLoading = recvBool;
        });
      },
      argUpdateAllDocList: (recvList) {
        allDocList = recvList;
      },
      argUpdateIsUploading: (_) {}
    );
  }
  // --------------------------------------------------------------------------------------------------------------

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


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
              // ----------------------------- タイトル -----------------------------
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth+100),
                child: PageTitle(
                  title: '申請書類一覧',
                  customColor: Color(0xFF0267B7),
                  leftZone: SizedBox(
                    width: 37,
                    child: reloadIconButton(
                      customIconSize: 22,
                      customColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(Duration(milliseconds: 600));
                        initializeFirebaseReferences();     // データの再読み込み
                      }
                    ),
                  ),
                ),
              ),
              // -------------------------------------------------------------------

              // ----------------------------- 書類表示 -----------------------------
              (isLoading)
              ? loadingAlertDialog()    // 読み込み中だったら、クルクルマークを表示
              : (allDocList.isEmpty)
                ? Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Text('何も登録されていません', style: TextStyle(fontSize: 21)),
                )
                : Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 2,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(allDocList.length, (index) {
                              return ApplyButton(
                                name: allDocList[index]['docName'],
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: SizedBox(
                                          height: 160,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(height: 10),
                                              SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
                                              SizedBox(height: 30),
                                              Text(
                                                '読み込み中...',
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                  await functionShowFirebasePdf(
                                    isFirebaseInitialized: _isFirebaseInitialized,
                                    context: context,
                                    fileName:  allDocList[index]['fileName'],
                                    fileUrl: allDocList[index]['fileUrl'],
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
                    ),
                  ),
                ),
              // -------------------------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
