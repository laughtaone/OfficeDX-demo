import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';



void functionQaFilter({
  required List<Map<String, dynamic>> allQaList,
  required List<String> searchCondList,
  required Function(List<Map<String, dynamic>>) argFilteredQaList,
  required Function(bool) argIsFiltering,
}) async {
  List<Map<String, dynamic>> keepAllQaList = [];

  try {
    argIsFiltering(true);

    if (searchCondList.isEmpty) {
      keepAllQaList = allQaList;
    } else {
       // フィルター処理
      keepAllQaList = allQaList.where((qa) {
        return searchCondList.contains(qa['categoryDocId']);
      }).toList();
    }

    argFilteredQaList(keepAllQaList);

    debugPrint('✅allQaListから検索条件でfilteredListに絞り込みに成功');
  } catch (e) {
    debugPrint('allQaListから検索条件でfilteredListに絞り込み中にエラー：$e');
  } finally {
    debugPrint('🦑 functionQaFilterが受け取ったリスト\n$searchCondList');
    debugPrint('🦑 functionQaFilterが生成したリスト\n$keepAllQaList');
    argIsFiltering(false);
  }
}