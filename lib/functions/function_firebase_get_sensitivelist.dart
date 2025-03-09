// Cloud Firestoreから不適切ワードを持ってくる
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


Future<void> funtionFirebaseGetSensitivelist({
  required FirebaseFirestore firestoreInstance,
  // required Function(bool) argUpdateIsLoading,
  required Function(List<String>) argUpdateSensitivelist,
}) async {
  try {
    // 処理開始時
    // argUpdateIsLoading(true);

    // コレクションからすべてのドキュメントを取得
    QuerySnapshot querySnapshot = await firestoreInstance.collection('sensitive_words').get();


    List<String> keepList = [];
    // ドキュメントデータをリストに変換して格納
    if (querySnapshot.docs.isEmpty) {
      debugPrint('不適切なワードが 未登録 or 取得時にエラー');
    } else {
      keepList = querySnapshot.docs.map((doc) {
        return doc['word'] as String;
      }).toList();
    }

    // 取得したリストを反映
    argUpdateSensitivelist(keepList);
    debugPrint('✅sensitiveListをCloud Firestoreから持ってくるのに成功');
  } catch (e) {
    debugPrint('Firebaseから書類名を持ってくる途中にエラー：$e');
  } finally {
    // argUpdateIsLoading(false);
  }
}

