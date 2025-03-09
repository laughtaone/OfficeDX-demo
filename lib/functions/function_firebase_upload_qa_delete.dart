import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future funtionFirebaseUploadQaDelete({
  required FirebaseFirestore firestoreInstance,
  required String targetDocId,
  required Function(bool) argIsDeletingCallback
}) async {
  argIsDeletingCallback(true);

  try {
    await FirebaseFirestore.instance.collection('qa_list').doc(targetDocId).delete();
  } catch (e) {
    debugPrint('【削除】Cloud FirestoreにあるQ&A情報の削除処理にエラー：$e');
  } finally {
    argIsDeletingCallback(false);
  }

  debugPrint('✅【削除】Cloud FirestoreからQ&A情報を削除する処理');
}