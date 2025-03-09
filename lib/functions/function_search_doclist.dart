// allDocListと検索ワードを引数として受け取り、検索ワードに合致した要素のみを格納したリストを返す関数



List<Map<String, dynamic>> searchDocList({
    required List<Map<String, dynamic>> allDocList,
    required String searchWord,
}) {
  List<Map<String, dynamic>> filteredDocList = [];       // 結果を格納するリスト

  for (var doc in allDocList) {
    if (doc['docName'] != null && doc['fileName'] != null &&
        (doc['docName'].contains(searchWord) || doc['fileName'].contains(searchWord))) {
      filteredDocList.add(doc);  // 一致するアイテムを結果リストに追加
    }
  }

  return filteredDocList;      // 一致した書類のリストを返す
}