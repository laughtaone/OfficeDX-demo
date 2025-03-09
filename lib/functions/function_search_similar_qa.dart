import 'package:fuzzy/fuzzy.dart';



// ローカル上で検索

String findSimilarQa({
  required String searchText,
  required List<Map<String, dynamic>> qaList
}) {
  // qaDataからすべての質問を抽出
  List<String> questions = qaList.map((qa) => qa['question'] as String).toList();

  // Fuzzyインスタンスを初期化
  final fuzzy = Fuzzy(questions);

  // あいまい検索を実行
  final result = fuzzy.search(searchText);

  // 最も類似した質問のqaDocIdを返す (一致するものがある場合)
  if (result.isNotEmpty) {
    final bestMatch = result.first;
    final matchedQuestion = bestMatch.item;
    final matchedIndex = questions.indexOf(matchedQuestion);
    return qaList[matchedIndex]['qaDocId'];     // 対応するqaDocIdを返す
  } else {
    return 'Not found';
  }
}
