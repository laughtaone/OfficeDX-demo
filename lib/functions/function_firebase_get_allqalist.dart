// Cloud Firestoreから書類名を持ってくる
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:office_dx/functions/function_variable.dart';



Future<void> funtionFirebaseGetAllqalist({
  required FirebaseFirestore firestoreInstance,
  required Function(List<Map<String, dynamic>>) argUpdateAllQaList,
  required Function(Map<String, Map<String, dynamic>>) argUpdateCategoryMap,
  required Function(bool) argUpdateIsLoading,
}) async {

  try {
    argUpdateIsLoading(true);
    // qa_listコレクションからすべてのドキュメントを取得
    QuerySnapshot qaListQuerySnapshot = await firestoreInstance.collection('qa_list').get();

    // ドキュメントデータをリストに変換して格納
    List<Map<String, dynamic>> keepAllQaList = [];
    keepAllQaList = qaListQuerySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return {
        'qaDocId': doc.id,
        'question': data['question'] ?? '',
        'answer': data['answer'] ?? '',
        'createdAt': data['createdAt'] ?? Timestamp.now(),
        'updatedAt': data['updatedAt'] ?? notUpdatedAt,
        'categoryDocId': data['categoryDocId'] ?? '',
      };
    }).toList();

    // createdAtが古い順にソート
    keepAllQaList.sort((a, b) {
      Timestamp createdAtA = a['createdAt'] ?? Timestamp.now();
      Timestamp createdAtB = b['createdAt'] ?? Timestamp.now();
      return createdAtA.compareTo(createdAtB);
    });

    argUpdateAllQaList(keepAllQaList);


    // debugPrint('【allQaList】');
    // allQaList.forEach((doc) {
    //   debugPrint('createdAtは${doc['createdAt'].runtimeType}');
    // });

    debugPrint('✅allQaListをCloud Firestoreから持ってくるのに成功');
  } catch (e) {
    debugPrint('Cloud FirestoreからallQaListを持ってくる途中にエラー：$e');
    argUpdateIsLoading(false);
  }

  try {
    // qa_categoryコレクションからすべてのドキュメントを取得
    QuerySnapshot qaCategoryQuerySnapshot = await firestoreInstance.collection('qa_category').get();

    // ドキュメントデータをリストに変換して格納
    Map<String, Map<String, dynamic>> keepCategoryMap = {};
    keepCategoryMap = {
      for (var doc in qaCategoryQuerySnapshot.docs)
        doc.id: {
          'categoryName': (doc.data() as Map<String, dynamic>?)?['categoryName'],
          'createdAt': (doc.data() as Map<String, dynamic>?)?['createdAt'] ?? Timestamp.now(),
          'updatedAt': (doc.data() as Map<String, dynamic>?)?['updatedAt'] ?? notUpdatedAt
        }
    };

    // createdAtが古い順にソート
    var sortedEntries = keepCategoryMap.entries.toList()
      ..sort((a, b) {
        Timestamp createdAtA = a.value['createdAt'] ?? Timestamp.now();
        Timestamp createdAtB = b.value['createdAt'] ?? Timestamp.now();
        return createdAtA.compareTo(createdAtB);
      });

    keepCategoryMap = Map.fromEntries(sortedEntries);

    argUpdateCategoryMap(keepCategoryMap);


    // debugPrint('【categoryList】');
    // categoryList.forEach((doc) {
    //   debugPrint('categoryNameは${doc['categoryName']}');
    // });

    debugPrint('✅categoryListをCloud Firestoreから持ってくるのに成功');
  } catch (e) {
    debugPrint('Cloud FirestoreからcategoryListを持ってくる途中にエラー：$e');
  } finally {
    argUpdateIsLoading(false);
  }
}