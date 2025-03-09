import 'package:fuzzy/fuzzy.dart';



// ローカル上で検索

String findSimilarDoc({
  required String searchText,
  required List<Map<String, dynamic>> docList
}) {
  // docListからすべての質問を抽出
  List<String> docs = docList.map((doc) => doc['docName'] as String).toList();

  // Fuzzyインスタンスを初期化
  final fuzzy = Fuzzy(docs);

  // あいまい検索を実行
  final result = fuzzy.search(searchText);

  // 最も類似した書類のdocIdを返す (一致するものがある場合)
  if (result.isNotEmpty) {
    final bestMatch = result.first;
    final matchedDoc = bestMatch.item;
    final matchedIndex = docs.indexOf(matchedDoc);
    return docList[matchedIndex]['docId'];
  } else {
    return 'Not found';
  }
}
