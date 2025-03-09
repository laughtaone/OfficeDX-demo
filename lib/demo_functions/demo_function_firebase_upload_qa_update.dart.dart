// デモ用の関数 (元コードの不要な部分は消さずにコメントアウトして実装)

import 'package:flutter/material.dart';
import 'package:office_dx/demo_functions/demo_function_wait.dart';
/*
import 'package:cloud_firestore/cloud_firestore.dart';
*/


Future demoFuntionFirebaseUploadQaUpload({
  /*
  required FirebaseFirestore firestoreInstance,
  required String targetDocId,
  required String question,
  required String answer,
  required String categoryDocId,
  */
  required Function(bool) argIsUploading
}) async {
  argIsUploading(true);


  /*
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('qa_list').doc(targetDocId).update({
      'question': question,
      'answer': answer,
      'categoryDocId': categoryDocId,
      'updatedAt': Timestamp.now(),
    });
  } catch (e) {
    debugPrint('【更新】Cloud FirestoreにQ&A情報をアップロード中にエラー：$e');
  } finally {
    argIsUploading(false);
  }
  */

  await demoFunctionWait(mSec: 3000);  // (デモ用) 1秒待機

  argIsUploading(false);
  debugPrint('✅【更新】Cloud Firestore にQ&A情報をアップロード完了');
}