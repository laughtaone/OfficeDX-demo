import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:office_dx/components/dialog_close.dart';
import 'package:office_dx/components/dropdown_border.dart';
import 'package:office_dx/components/qna_detail_comp.dart';
import 'package:office_dx/components/textfield_border.dart';
import 'package:office_dx/components/uploading_dialog.dart';
import 'package:office_dx/demo_components/demo_caution.dart';
import 'package:office_dx/demo_components/demo_uploading_dialog.dart';
import 'package:office_dx/demo_functions/demo_function_firebase_upload_qa_update.dart.dart';
import 'package:office_dx/functions/function_firebase_upload_qa_new.dart';
import 'package:office_dx/functions/function_firebase_upload_qa_update.dart';
import 'package:office_dx/functions/function_variable.dart';
import 'package:office_dx/pages/admin_page/manage_document/manage_document.dart';
import 'package:office_dx/pages/admin_page/manage_qa/manage_qa.dart';




class SubcompQaDialog extends StatefulWidget {
  const SubcompQaDialog({super.key,
    required this.firestoreInstance,
    required this.isEdit,      // trueで「編集」・falseで「新規追加」

    // required this.argQuestionText,
    required this.oldQuestionText,

    // required this.argAnswerText,
    required this.oldAnswerText,

    // required this.argSelectCategory,
    required this.oldSelectedCategoryDocId,
    required this.categoryMap,

    required this.argCompleteUpload,

    required this.targetDocId
  });

  final FirebaseFirestore firestoreInstance;
  final bool isEdit;

  // final void Function(String) argQuestionText;
  final String oldQuestionText;

  // final void Function(String) argAnswerText;
  final String oldAnswerText;

  // final void Function(String?) argSelectCategory;
  final String? oldSelectedCategoryDocId;
  final Map<String, Map<String, dynamic>> categoryMap;

  final void Function(bool) argCompleteUpload;

  final String targetDocId;

  @override
  SubcompQaDialogState createState() => SubcompQaDialogState();
}


class SubcompQaDialogState extends State<SubcompQaDialog> {
  String newQuestion = '';
  String newAnswer = '';
  String newSelectedCategoryDocId = '';
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    setState(() {
      newQuestion = widget.oldQuestionText;
      newAnswer = widget.oldAnswerText;
      newSelectedCategoryDocId = widget.oldSelectedCategoryDocId ?? '';
      isEdit = widget.isEdit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DialogClose(
      dialogTitle: (isEdit) ? 'Q&Aを編集' : 'Q&Aを追加',
      customBackColor: Color(0xffF6FBFD),
      // ----------------------------------- 閉じるボタン -----------------------------------
      onPressedCloseButton: ((newQuestion != widget.oldQuestionText) || (newAnswer != widget.oldAnswerText) || (newSelectedCategoryDocId != widget.oldSelectedCategoryDocId))
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
        // - - - - - - - - - - - - 質問文入力フィールド - - - - - - - - - - - -
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 7),
            child: dialogSubtitleText('質問文'),
          ),
          (isEdit && widget.oldQuestionText!=newQuestion) ? changedDisplay() : SizedBox.shrink()
        ]),
        TextfieldBorder(
          height: 120,
          nowText: widget.oldQuestionText,
          onChanged: (String recvString) {
            setState(() {
              newQuestion = recvString;
            });
          },
        ),
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        SizedBox(height: 11),

        // - - - - - - - - - - - - 回答文入力フィールド - - - - - - - - - - - -
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 7),
            child: dialogSubtitleText('回答文'),
          ),
          (isEdit && widget.oldAnswerText!=newAnswer) ? changedDisplay() : SizedBox.shrink()
        ]),
        TextfieldBorder(
          height: 170,
          nowText: widget.oldAnswerText,
          onChanged: (String recvString) {
            setState(() {
              newAnswer = recvString;
            });
          },
        ),
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        SizedBox(height: 11),

        // - - - - - - - - - - - - カテゴリ選択フィールド - - - - - - - - - - -
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 7),
            child: dialogSubtitleText('カテゴリ')
          ),
          (isEdit && widget.oldSelectedCategoryDocId!=newSelectedCategoryDocId) ? changedDisplay() : SizedBox.shrink()
        ]),
        DropdownBorder(
          nowSelectedCategory: newSelectedCategoryDocId,
          categoryMap: widget.categoryMap,
          onChanged: (String? recvText) {
            setState(() {
              newSelectedCategoryDocId = recvText ?? '';
            });
          }
        ),
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        SizedBox(height: 32),
        // - - - - - - - - - - - - - - - 保存ボタン - - - - - - - - - - - - -
        SizedBox(
          height: 65,
          width: 160,
          child: ElevatedButton(
            onPressed:
              (newQuestion.isNotEmpty && newAnswer.isNotEmpty && newSelectedCategoryDocId.isNotEmpty) &&
              (isEdit
                ? (newQuestion != widget.oldQuestionText || newAnswer != widget.oldAnswerText || newSelectedCategoryDocId != widget.oldSelectedCategoryDocId)
                : true
              )

              ? () {
                FocusScope.of(context).unfocus();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: const EdgeInsets.only(left: 10, right: 10),
                      backgroundColor: Color(0xffeaf0f8),
                      title: Text('確認'),
                      content: SizedBox(
                        width: 440,
                        height: 530,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('次の内容で保存されます。\nよろしいですか？', style: TextStyle(fontSize: 17)),
                            SizedBox(height: 8),
                            // ---------------- デモ用警告 ----------------
                            DemoCaution(isHeightFixed: false),
                            SizedBox(height: 8),
                            // -------------------------------------------
                            dialogSubtitleText('実際の表示イメージ'),
                            Text(
                              '上下にスクロール可能です',
                              style: TextStyle(fontSize: 13, color: Color(0xff686868), fontWeight: FontWeight.w500),
                            ),
                            Divider(thickness: 1.5, color: Color(0xFF9FC7E7)),
                            SizedBox(
                              height: 350,
                              child: SingleChildScrollView(
                                child: Container(
                                  color: Colors.white,
                                  child: QNADetailComp(
                                    question: newQuestion,
                                    answer: newAnswer,
                                    createdAt: formatDateAndTime(Timestamp.now()),
                                    categoryName: widget.categoryMap[newSelectedCategoryDocId]?['categoryName'] ?? '',
                                    updatedAt: formatDateAndTime(notUpdatedAt),
                                  ),
                                ),
                              ),
                            ),
                            Divider(thickness: 1.5, color: Color(0xFF9FC7E7)),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text("OK", style: TextStyle(fontSize: 20)),
                          onPressed: () async{
                            bool isUploading2 = true;
                              
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return uploadingDialog(type: (isEdit) ? 2 : 1);
                                return demoUploadingDialog(type: (isEdit) ? 2 : 1);   // (デモ用)アップロードダイアログに変更
                              },
                            );

                            // isEditが、true：更新アップロード・false：新規アップロード
                            if (isEdit) {
                              /*
                              await funtionFirebaseUploadQaUpload(
                                firestoreInstance: widget.firestoreInstance,
                                targetDocId: widget.targetDocId,
                                question: newQuestion,
                                answer: newAnswer,
                                categoryDocId: newSelectedCategoryDocId,
                                argIsUploading: (bool recvBool) {
                                  setState(() {
                                    isUploading2 = recvBool;
                                  });
                                }
                              );
                              */
                              // (デモ用) Firebaseの内容を変更する処理を行わず、アップロード中の表示だけを行う

                              await demoFuntionFirebaseUploadQaUpload(
                                argIsUploading: (bool recvBool) {
                                  setState(() {
                                    isUploading2 = recvBool;
                                  });
                                }
                              );
                            } else {
                              /*
                              await funtionFirebaseUploadQaNew(
                                firestoreInstance: widget.firestoreInstance,
                                question: newQuestion,
                                answer: newAnswer,
                                categoryDocId: newSelectedCategoryDocId,
                                argUpdateIsUploading: (bool recvBool) {
                                  setState(() {
                                    isUploading2 = recvBool;
                                  });
                                },
                              );
                              */
                              // (デモ用) Firebaseへ追加する処理を行わず、アップロード中の表示だけを行う
                              await demoFuntionFirebaseUploadQaUpload(
                                argIsUploading: (bool recvBool) {
                                  setState(() {
                                    isUploading2 = recvBool;
                                  });
                                }
                              );
                            }
                            

                            if (!isUploading2) {
                              if (mounted){
                                Navigator.of(context).pop();
                              }
                            }

                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            widget.argCompleteUpload(true);
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