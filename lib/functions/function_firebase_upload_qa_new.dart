import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future funtionFirebaseUploadQaNew({
  required FirebaseFirestore firestoreInstance,
  required String question,                 // 質問文
  required String answer,                   // 回答文
  required String categoryDocId,            // カテゴリ
  required Function(bool) argUpdateIsUploading,
}) async {
  argUpdateIsUploading(true);

  try {
    // ↓ Firestoreに情報を書き込み
    await firestoreInstance.collection('qa_list').add({
      'question': question,
      'answer': answer,
      'categoryDocId': categoryDocId,
      'createdAt': Timestamp.now(), // 現在の日時
    });
  } catch (e) {
    debugPrint('【追加】Cloud FirestoreにQ&A情報を追加する処理中にエラー：$e');
  } finally {
    argUpdateIsUploading(false);
  }

  debugPrint('✅【追加】Cloud FirestoreにQ&A情報を追加する処理');
}