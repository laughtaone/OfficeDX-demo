// Cloud Firestoreから書類名を持ってくる
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:office_dx/functions/function_variable.dart';


/*　argUpdateIsUploadingが不要な時：
argUpdateIsUploading: (_) {}
でOK */



Future<void> funtionFirebaseGetAlldoclist({
  required FirebaseFirestore firestoreInstance,
  required Function(bool) argUpdateIsLoading,
  required Function(bool) argUpdateIsUploading,
  required Function(List<Map<String, dynamic>>) argUpdateAllDocList,
}) async {
  try {
    // 処理開始時
    argUpdateIsLoading(true);
    argUpdateIsUploading(true);

    debugPrint('🤣🤣🤣🤣🤣');

    // コレクションからすべてのドキュメントを取得
    QuerySnapshot querySnapshot = await firestoreInstance.collection('document_records').get();

    // ドキュメントデータをリストに変換して格納
    List<Map<String, dynamic>> keepAllDocList = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return {
        'docId': doc.id,
        'docName': data['docName'] ?? '',
        'fileUrl': data['fileUrl'] ?? '',
        'fileName': data['fileName'] ?? '',
        'createdAt': data['createdAt'] ?? Timestamp.now(),
        'updatedAt': data['updatedAt'] ?? notUpdatedAt,
      };
    }).toList();

    // createdAtが古い順にソート
    keepAllDocList.sort((a, b) {
      Timestamp createdAtA = a['createdAt'] ?? Timestamp.now();
      Timestamp createdAtB = b['createdAt'] ?? Timestamp.now();
      return createdAtA.compareTo(createdAtB);
    });

    argUpdateAllDocList(keepAllDocList);


    // 取得したリストを反映
    argUpdateAllDocList(keepAllDocList);

    // アップロード完了状態を通知
    argUpdateIsUploading(false);

    debugPrint('✅allDocListをCloud Firestoreから持ってくるのに成功');
  } catch (e) {
    debugPrint('Firebaseから書類名を持ってくる途中にエラー：$e');
    argUpdateIsUploading(false);
  } finally {
    argUpdateIsLoading(false);
  }
}

