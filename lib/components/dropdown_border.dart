import 'package:flutter/material.dart';

class DropdownBorder extends StatelessWidget {
  final String? nowSelectedCategory; // 現在選ばれている値
  final Map<String, Map<String, dynamic>> categoryMap;
  final Function(String?) onChanged;
  final String hintText;

  const DropdownBorder({
    super.key,
    required this.nowSelectedCategory,
    required this.categoryMap,
    required this.onChanged,
    this.hintText = '未選択',
  });

  @override
  Widget build(BuildContext context) {
    // nowSelectedCategoryがcategoryMapのキーに存在しない場合、デフォルト値を空文字に設定
    final String? validSelectedCategory = categoryMap.containsKey(nowSelectedCategory)
      ? nowSelectedCategory
      : null;

    return Container(
      alignment: Alignment.center,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF0267B7),
          width: 2
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: DropdownButton(
        value: validSelectedCategory,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        hint: Text(hintText, style: TextStyle(color: Color(0xffE5534F))), // ヒントテキスト
        items: categoryMap.keys.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(categoryMap[item]?['categoryName'] ?? ''),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
