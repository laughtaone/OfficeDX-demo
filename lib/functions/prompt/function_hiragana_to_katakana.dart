// 引数として受け取ったテキスト内のひらがなをカタカナに変換して返す関数



String hiraganaToKatakana(String text) {
  String output = text.replaceAllMapped(RegExp(r'[ぁ-ん]'), (match) {
    return String.fromCharCode(match.group(0)!.codeUnitAt(0) + 0x60);
  });

  return output;
}