// allQaListと検索ワードを引数として受け取り、検索ワードに合致した要素のみを格納したリストを返す関数



List<Map<String, dynamic>> searchQaList({
  required List<Map<String, dynamic>> allQaList,
  required String searchWord,
}) {
  List<Map<String, dynamic>> filteredQaList = [];       // 結果を格納するリスト

  for (var qa in allQaList) {
    if (qa['question'] != null && qa['answer'] != null &&
        (qa['question'].contains(searchWord) || qa['answer'].contains(searchWord))) {
      filteredQaList.add(qa);  // 一致するアイテムを結果リストに追加
    }
  }

  return filteredQaList;      // 一致したQAのリストを返す
}