import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future functionFirebaseUploadDocDelete({
  required FirebaseFirestore firestoreInstance,
  required FirebaseStorage storageInstance,
  required String targetDocId,
  required String targetFileUrl,
  required Function(bool) argIsDeletingCallback
}) async {
  argIsDeletingCallback(true);

  // --------------------- Firebase Storageにあるファイルの削除処理 ------------------
  try {
    final storageReference = storageInstance.refFromURL(targetFileUrl);
    await storageReference.delete();
  } catch (e) {
    debugPrint('❌【削除】Firebase Storageにあるファイルの削除処理にエラー：$e');
  }
  // -----------------------------------------------------------------------------

  // ------------------ Cloud Firestoreにあるファイルの削除処理 ----------------------
  try {
    await firestoreInstance
      .collection('document_records')
      .doc(targetDocId)
      .delete();
  } catch (e) {
    debugPrint('❌【削除】Cloud Firestoreにあるファイル情報の削除処理にエラー：$e');
  }
  // -----------------------------------------------------------------------------

  debugPrint('✅【削除】Firebase Storage/Cloud FireStore から削除する処理完了');
  argIsDeletingCallback(false);
}