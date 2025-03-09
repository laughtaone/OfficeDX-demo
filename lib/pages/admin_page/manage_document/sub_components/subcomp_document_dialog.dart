import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:office_dx/components/apply_button.dart';
import 'package:office_dx/demo_components/demo_caution.dart';
import 'package:office_dx/components/dialog_close.dart';
import 'package:office_dx/components/uploading_dialog.dart';
import 'package:office_dx/demo_components/demo_uploading_dialog.dart';
import 'package:office_dx/demo_functions/demo_function_firebase_upload_doc_update.dart';
import 'package:office_dx/functions/function_firebase_upload_doc_new.dart';
import 'package:office_dx/functions/function_firebase_upload_doc_update.dart';
import 'package:office_dx/functions/function_pick_file.dart';
import 'package:office_dx/pages/admin_page/manage_document/manage_document.dart';
import 'package:file_picker/file_picker.dart';





class SubcompDocumentDialog extends StatefulWidget {
  const SubcompDocumentDialog({super.key,
    required this.firestoreInstance,
    required this.storageInstance,
    required this.isEdit,      // trueで「編集」・falseで「新規追加」

    required this.oldDocName,

    required this.oldFileName,

    required this.argCompleteUpload,

    required this.targetDocId,
    required this.oldFileUrl
  });

  final FirebaseFirestore firestoreInstance;
  final FirebaseStorage storageInstance;
  final bool isEdit;

  final String oldDocName;

  final String oldFileName;

  final void Function(bool) argCompleteUpload;

  final String targetDocId;
  final String oldFileUrl;

  @override
  SubcompDocumentDialogState createState() => SubcompDocumentDialogState();
}


class SubcompDocumentDialogState extends State<SubcompDocumentDialog> {
  late TextEditingController newDocNameController;
  String newDocName = '';
  String newFileName = '';
  String newSelectedCategoryDocId = '';
  late bool isEdit;
  FilePickerResult? resultSelectedFile;

  bool isFileChanged = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      newDocNameController = TextEditingController(text: widget.oldDocName);
      newDocName = widget.oldDocName;
      newFileName = widget.oldFileName;
      isEdit = widget.isEdit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DialogClose(
      customMobileWidth: 280,
      customPCWidth: 350,
      dialogTitle: (isEdit) ? '書類を編集' : '書類を追加',
      customBackColor: Color(0xffF6FBFD),
      // ----------------------------------- 閉じるボタン -----------------------------------
      onPressedCloseButton: (newDocName != widget.oldDocName) || (isFileChanged)
        ? () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('確認'),
                content: Text('入力された内容を破棄して閉じますか？'),
                actions: [
                  TextButton(
                    child: Text("OK", style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("キャンセル", style: TextStyle(color: Colors.red, fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
          );
        }
        : () {
          Navigator.of(context).pop();
        },
      // ----------------------------------------------------------------------------------
      content: Column(children: [
        // - - - - - - - - - - - - 書類名入力フィールド - - - - - - - - - - - -
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 7),
            child: dialogSubtitleText('表示する書類名'),
          ),
          (isEdit && newDocName != widget.oldDocName) ? changedDisplay() : SizedBox.shrink()
        ]),
        TextField(
          onChanged: (String recvText) {
            setState(() {
              newDocName = recvText;
            });
          },
          controller: newDocNameController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: '未入力',
            hintStyle: TextStyle(color: Color(0xffE5534F)),
          )
        ),
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        SizedBox(height: 20),

        // - - - - - - - - - - - - - - PDFフィールド - - - - - - - - - - - - -
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 7),
            child: dialogSubtitleText('掲載するPDFファイル')
          ),
          (isEdit && isFileChanged) ? changedDisplay() : SizedBox.shrink()
        ]),
        TextButton(
          onPressed: () {
            functionPickFile(
              argFileNameCallback: (String recvFileName) {
                setState(() {
                  newFileName = recvFileName;
                });
              },
              argFilePickerResultCallback: (FilePickerResult? recvFilePickr) {
                setState(() {
                  resultSelectedFile = recvFilePickr;
                  isFileChanged = true;
                });
              },
            );
          },
          style: TextButton.styleFrom(
            fixedSize: const Size(double.infinity, 60),
            backgroundColor: Color(0xffe0e0e0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  (newFileName.isEmpty) ? '未選択' : newFileName,
                  style: TextStyle(fontSize: 15, color: (newFileName.isEmpty) ?Color(0xffE5534F) :Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.edit, size: 22, color: Colors.black),
            ],
          ),
        ),
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        SizedBox(height: 32),
        // - - - - - - - - - - - - - - - 保存ボタン - - - - - - - - - - - - -
        SizedBox(
          height: 65,
          width: 160,
          child: ElevatedButton(
            onPressed:
              (newDocName.isNotEmpty && newFileName.isNotEmpty) &&
              (isEdit
                ? (newDocName != widget.oldDocName || newFileName != widget.oldFileName)
                : true
              )

              ? () {
                FocusScope.of(context).unfocus();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    double screenWidth = MediaQuery.of(context).size.width;    // 画面の幅を取得
                    return AlertDialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Color(0xffeaf0f8),
                      title: Text('確認'),
                      content: SizedBox(
                        height: 425,
                        width: (screenWidth > 800) ? 450 : 350,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('次の内容で保存されます。\nよろしいですか？', style: TextStyle(fontSize: 17)),
                              SizedBox(height: 20),
                              // ---------------- デモ用警告 ----------------
                              DemoCaution(),
                              // -------------------------------------------
                              SizedBox(height: 20),
                              // ------------------ 書類名 ------------------
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  dialogSubtitleText('実際の表示イメージ'),
                                  (isEdit && newDocName != widget.oldDocName)
                                    ? changedDisplay()
                                    : SizedBox.shrink()
                                ],
                              ),
                              explainTextLocalComp('学生には次のように表示されます'),
                              Center(
                                child: SizedBox(
                                  height: 75,
                                  width: 300,
                                  child: ApplyButton(
                                    name: newDocName,
                                    needTBPadding: false,
                                    needLRPadding: false,
                                    customFontSize: 21,
                                    onPressed: () => {}
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Center(child: Text(
                                '↑ ここではタップしてもPDFは表示されません',
                                style: TextStyle(fontSize: 11, color: Color(0xff686868)),
                              )),
                              // -------------------------------------------
                                
                              SizedBox(height: 22),
                                
                              // ------------------ PDF名 ------------------
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  subtitleLocalComp(recvText: '掲載するPDFファイル', mini: true),
                                  (isEdit && isFileChanged)
                                    ? changedDisplay()
                                    : SizedBox.shrink()
                                ],
                              ),
                              explainTextLocalComp('学生がPDFをダウンロードすると、次のファイル名となります'),
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white
                                ),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Flexible(flex: 1, child: Icon(Icons.attach_file_outlined, size: 21)),
                                  SizedBox(width: 5),
                                  Flexible(
                                    flex: 5,
                                    child: Text(
                                      newFileName,
                                      style: TextStyle(fontSize: 17), overflow: TextOverflow.ellipsis, maxLines: 2,
                                    )
                                  ),
                                ]),
                              ),
                              // -------------------------------------------
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text("OK", style: TextStyle(fontSize: 20)),
                          onPressed: () async{
                            bool isUploading = true;
                            late int updateType;      // 書類名とファイル両方変更なら0・書類名のみ変更なら1・ファイルのみ変更なら2
                            if ((newDocName != widget.oldDocName) && isFileChanged) {
                              updateType = 0;
                            } else if (isFileChanged) {
                              updateType = 2;
                            } else {
                              updateType = 1;
                            }
      
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return uploadingDialog(type: (isEdit) ? 2 : 1);
                                return demoUploadingDialog(type: (isEdit) ? 2 : 1);     // (デモ用)アップロードダイアログに変更
                              },
                            );

                            // isEditが、true：更新アップロード・false：新規アップロード
                            if (isEdit) {
                              /*
                              await functionFirebaseUploadDocUpdate(
                                firestoreInstance: widget.firestoreInstance,
                                storageInstance: widget.storageInstance,
                                targetDocId: widget.targetDocId,
                                updateType: updateType,
                                argIsUploadingCallback: (bool recvBool) {
                                  setState(() {
                                    isUploading = recvBool;
                                  });
                                },
                                newDocName: newDocName,
                                uploadFile: resultSelectedFile,
                                oldFileUrl: widget.oldFileUrl,
                                argResultSelectedFile: (FilePickerResult? recvFilePickerResult) {
                                  setState(() {
                                    resultSelectedFile = recvFilePickerResult;
                                  });
                                }
                              );
                              */
                              // (デモ用) Firebaseの内容を変更する処理を行わず、アップロード中の表示だけを行う
                              await demoFunctionFirebaseUploadDocUpdate(
                                argIsUploadingCallback: (bool recvBool) {
                                  setState(() {
                                    isUploading = recvBool;
                                  });
                                },
                                argResultSelectedFile: (FilePickerResult? recvFilePickerResult) {
                                  setState(() {
                                    resultSelectedFile = recvFilePickerResult;
                                  });
                                }
                              );
                            } else {
                              /*
                              await functionFirebaseUploadDocNew(
                                firestoreInstance: widget.firestoreInstance,
                                storageInstance: widget.storageInstance,
                                uploadFile: resultSelectedFile,
                                docName: newDocName,
                                argUpdateIsUploading: (bool recvBool) {
                                  setState(() {
                                    isUploading = recvBool;
                                  });
                                },
                                argResultSelectedFile: (FilePickerResult? recvFilePickerResult) {
                                  setState(() {
                                    resultSelectedFile = recvFilePickerResult;
                                  });
                                }
                              );
                              */
                              // (デモ用) Firebaseへ追加する処理を行わず、アップロード中の表示だけを行う
                              await demoFunctionFirebaseUploadDocUpdate(
                                argIsUploadingCallback: (bool recvBool) {
                                  setState(() {
                                    isUploading = recvBool;
                                  });
                                },
                                argResultSelectedFile: (FilePickerResult? recvFilePickerResult) {
                                  setState(() {
                                    resultSelectedFile = recvFilePickerResult;
                                  });
                                }
                              );
                            }

                            

                            if (!isUploading) {
                              if (mounted){
                                widget.argCompleteUpload(true);
                                Navigator.of(context).pop();
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            }

                            debugPrint('🐤【変更(処理後)】resultSelectedFileは、$resultSelectedFile');

                            
                          },
                        ),
                        TextButton(
                          child: Text("キャンセル", style: TextStyle(color: Colors.red, fontSize: 20)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }
                );
              }
              : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              disabledBackgroundColor: Colors.blue.withValues(alpha: 0.2),
            ),
            child: const Text('保存', style: TextStyle(color: Colors.white, fontSize: 18))
          )
        ),
        SizedBox(height: 20)
        // ----------------------------------------------------------------
      ]),
    );
  }
}






Text dialogSubtitleText(recvText) {
  return Text(
    recvText,
    overflow: TextOverflow.clip,
    maxLines: 1,
    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)
  );
}



Container changedDisplay({String customText = '変更あり'}) {
  final Color mainColor = Color(0xff1E90FF);
  return Container(
    padding: const EdgeInsets.fromLTRB(6, 4, 6, 4) ,
    decoration: BoxDecoration(
      color: Color(0xffD0E8F3),
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

Padding explainTextLocalComp(recvText) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      recvText,
      style: TextStyle(fontSize: 13, color: Color(0xff222222))
    ),
  );
}