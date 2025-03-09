// プロンプトを引数として受け取り、そのプロンプトが質問を次の項目に該当しないかを返す関数
// 該当する：該当するkindの文字列を返す・意図しない：文字列'true'を返す


import 'package:office_dx/functions/prompt/function_hiragana_to_katakana.dart';




String functionCheckPrompt({
  required String promptText,
  required List<String> sensitiveWordsList
}) {
  List<String> simbolList = [
    '@', '!', '#', '\$', '%', '^', '&', '*', '(', ')', '-', '=', '+', '[', ']', '{', '}', '\\', '|', ';', ':', '\'', '"', ',', '.', '/', '<', '>', '?', '~', '`'
  ];

  List<Map<String, String>> checkList = [
    // チャット終了を促す項目（'kind': 'goodbye'）
    {'text': 'さよなら', 'kind': 'goodbye'},
    {'text': 'さようなら', 'kind': 'goodbye'},
    {'text': 'ばいばい', 'kind': 'goodbye'},
    {'text': 'Good bye', 'pronunciation': 'グッバイ', 'kind': 'goodbye'},
    {'text': 'Goodbye', 'pronunciation': 'グッバイ', 'kind': 'goodbye'},
    {'text': 'じゃあね', 'kind': 'goodbye'},
    {'text': 'またね', 'kind': 'goodbye'},
    {'text': '失礼します', 'pronunciation': 'しつれいします', 'kind': 'goodbye'},
    {'text': '行ってきます', 'pronunciation': 'いってきます', 'kind': 'goodbye'},


    // 「わからない」と回答する項目（'kind': 'idontknow'）
    {'text': 'すご', 'kind': 'idontknow'},
    {'text': 'すごい', 'kind': 'idontknow'},
    {'text': 'おもろ', 'kind': 'idontknow'},
    {'text': '面白い', 'pronunciation': 'おもしろい', 'kind': 'idontknow'},
    {'text': '疲れました', 'pronunciation': 'つかれました', 'kind': 'idontknow'},
    {'text': '疲れた', 'pronunciation': 'つかれた', 'kind': 'idontknow'},
    {'text': '楽しい', 'pronunciation': 'たのしい', 'kind': 'idontknow'},
    {'text': '悲しい', 'pronunciation': 'かなしい', 'kind': 'idontknow'},
    {'text': 'うるさい', 'pronunciation': 'うるさい', 'kind': 'idontknow'},
    {'text': 'お腹すいた', 'pronunciation': 'おなかすいた', 'kind': 'idontknow'},
    {'text': 'やった', 'pronunciation': 'やった', 'kind': 'idontknow'},
    {'text': '最高', 'pronunciation': 'さいこう', 'kind': 'idontknow'},
    {'text': '満足', 'pronunciation': 'まんぞく', 'kind': 'idontknow'},
    {'text': '嬉しい', 'pronunciation': 'うれしい', 'kind': 'idontknow'},
    {'text': '眠い', 'pronunciation': 'ねむい', 'kind': 'idontknow'},
    {'text': '驚き', 'pronunciation': 'おどろき', 'kind': 'idontknow'},
    {'text': 'わかる', 'pronunciation': 'わかる', 'kind': 'idontknow'},
    {'text': 'だめ', 'pronunciation': 'だめ', 'kind': 'idontknow'},
    {'text': '困った', 'pronunciation': 'こまった', 'kind': 'idontknow'},
    {'text': '良い', 'pronunciation': 'よい', 'kind': 'idontknow'},
    {'text': 'おいしい', 'pronunciation': 'おいしい', 'kind': 'idontknow'},
    {'text': '大丈夫', 'pronunciation': 'だいじょうぶ', 'kind': 'idontknow'},
    {'text': '忙しい', 'pronunciation': 'いそがしい', 'kind': 'idontknow'},
    {'text': '残念', 'pronunciation': 'ざんねん', 'kind': 'idontknow'},
    {'text': 'ごめんなさい', 'pronunciation': 'ごめんなさい', 'kind': 'idontknow'},
    {'text': 'すみません', 'pronunciation': 'すみません', 'kind': 'idontknow'},
    {'text': 'いいえ', 'pronunciation': 'いいえ', 'kind': 'idontknow'},
    {'text': 'お疲れ様', 'pronunciation': 'おつかれさま', 'kind': 'idontknow'},
    {'text': '大好き', 'pronunciation': 'だいすき', 'kind': 'idontknow'},
    {'text': '助けて', 'pronunciation': 'たすけて', 'kind': 'idontknow'},
    {'text': '気になる', 'pronunciation': 'きになる', 'kind': 'idontknow'},
    {'text': '安心', 'pronunciation': 'あんしん', 'kind': 'idontknow'},
    {'text': '怖い', 'pronunciation': 'こわい', 'kind': 'idontknow'},
    {'text': '嬉しい', 'pronunciation': 'うれしい', 'kind': 'idontknow'},
    {'text': 'わかりました', 'pronunciation': 'わかりました', 'kind': 'idontknow'},
    {'text': '楽しくなかった', 'pronunciation': 'たのしくなかった', 'kind': 'idontknow'},
    {'text': '嫌い', 'pronunciation': 'きらい', 'kind': 'idontknow'},
    {'text': '面倒くさい', 'pronunciation': 'めんどうくさい', 'kind': 'idontknow'},
    {'text': 'しんどい', 'pronunciation': 'しんどい', 'kind': 'idontknow'},
    {'text': '幸せ', 'pronunciation': 'しあわせ', 'kind': 'idontknow'},
    {'text': 'すばらしい', 'pronunciation': 'すばらしい', 'kind': 'idontknow'},
    {'text': '疲れた', 'pronunciation': 'つかれた', 'kind': 'idontknow'},
    {'text': '面倒だ', 'pronunciation': 'めんどうだ', 'kind': 'idontknow'},
    {'text': '心配', 'pronunciation': 'しんぱい', 'kind': 'idontknow'},
    {'text': '友達になろ', 'pronunciation': 'ともだちになろ', 'kind': 'idontknow'},
    {'text': '友達になって', 'pronunciation': 'ともだちになって', 'kind': 'idontknow'},

    // あいさつの項目（'kind': 'greeting'）
    {'text': 'こんにちは', 'kind': 'greeting'},
    {'text': 'おはよう', 'kind': 'greeting'},
    {'text': 'おはよ', 'kind': 'greeting'},
    {'text': 'おやすみ', 'kind': 'greeting'},
    {'text': '初めまして', 'pronunciation': 'はじめまして', 'kind': 'greeting'},
    {'text': 'よろしく', 'kind': 'greeting'},
    {'text': '久しぶり', 'pronunciation': 'ひさしぶり', 'kind': 'greeting'},
    {'text': 'お疲れ', 'pronunciation': 'おつかれ', 'kind': 'greeting'},
    {'text': 'こんちは', 'kind': 'greeting'},
    {'text': 'こんちわ', 'kind': 'greeting'},
    {'text': 'こんちくわ', 'kind': 'greeting'},
    {'text': 'Hello', 'pronunciation': 'ハロー', 'kind': 'greeting'},
    {'text': 'Good morning', 'pronunciation': 'グッドモーニング', 'kind': 'greeting'},
    {'text': 'Hello', 'pronunciation': 'ハロー', 'kind': 'greeting'},
    {'text': '你好', 'pronunciation': 'ニーハオ', 'kind': 'greeting'},
    {'text': '안녕하세요', 'pronunciation': 'アニョハセヨ', 'kind': 'greeting'},
    {'text': 'Bonjour', 'pronunciation': 'ボンジュール', 'kind': 'greeting'},
    {'text': 'Hallo', 'pronunciation': 'ハロー', 'kind': 'greeting'},
    {'text': 'Hola', 'pronunciation': 'オラ', 'kind': 'greeting'},
    {'text': 'Ciao', 'pronunciation': 'チャオ', 'kind': 'greeting'},
    {'text': 'Здравствуйте', 'pronunciation': 'ズドラーストヴィチェ', 'kind': 'greeting'},
    {'text': 'Olá', 'pronunciation': 'オラ', 'kind': 'greeting'},
    {'text': 'مرحباً', 'pronunciation': 'マルハバ', 'kind': 'greeting'},
    {'text': 'नमस्ते', 'pronunciation': 'ナマステ', 'kind': 'greeting'},
    {'text': 'สวัสดี', 'pronunciation': 'サワッディー', 'kind': 'greeting'},
    {'text': 'Xin chào', 'pronunciation': 'シンチャオ', 'kind': 'greeting'},
    {'text': 'Halo', 'pronunciation': 'ハロー', 'kind': 'greeting'},
    {'text': 'Kamusta', 'pronunciation': 'カムスタ', 'kind': 'greeting'},
    {'text': 'Γειά σας', 'pronunciation': 'ヤーサス', 'kind': 'greeting'},
    {'text': 'Merhaba', 'pronunciation': 'メルハバ', 'kind': 'greeting'},
    {'text': 'سلام', 'pronunciation': 'サラーム', 'kind': 'greeting'},
    {'text': 'Hej', 'pronunciation': 'ヘイ', 'kind': 'greeting'},
    {'text': 'Hei', 'pronunciation': 'ヘイ', 'kind': 'greeting'},
    {'text': 'Hej', 'pronunciation': 'ヘイ', 'kind': 'greeting'},
    {'text': 'Hallo', 'pronunciation': 'ハロー', 'kind': 'greeting'},
    {'text': 'Helló', 'pronunciation': 'ヘロー', 'kind': 'greeting'},
    {'text': 'Ahoj', 'pronunciation': 'アホイ', 'kind': 'greeting'},
    {'text': 'Cześć', 'pronunciation': 'チェシュチ', 'kind': 'greeting'},
    {'text': 'Hei', 'pronunciation': 'ヘイ', 'kind': 'greeting'},
    {'text': 'Bună', 'pronunciation': 'ブナ', 'kind': 'greeting'},

    // ミニゲームの項目（'kind': 'game'）
    {'text': 'ゲーム', 'pronunciation': 'げーむ', 'kind': 'game'},
    {'text': '暇', 'pronunciation': 'ひま', 'kind': 'game'},
    {'text': '退屈', 'pronunciation': 'たいくつ', 'kind': 'game'},
    {'text': '遊ぼ', 'pronunciation': 'あそぼ', 'kind': 'game'},
    {'text': 'やることない', 'kind': 'game'},
    {'text': 'つまんない', 'kind': 'game'},
    {'text': 'つまらない', 'kind': 'game'},
    {'text': '気分転換', 'pronunciation': 'きぶんてんかん', 'kind': 'game'},
    {'text': 'おもんない', 'kind': 'game'},
    {'text': 'おもろない', 'kind': 'game'},
    {'text': '面白くない', 'pronunciation': 'おもしろくない', 'kind': 'game'},
    {'text': '面白いこと', 'pronunciation': 'おもしろいこと', 'kind': 'game'},
    {'text': '🎮', 'kind': 'game'},
    {'text': 'game', 'kind': 'game'},
    {'text': 'げいむ', 'kind': 'game'},
    {'text': 'げえむ', 'kind': 'game'},

    // 不適切なワードの項目（具体的なワードはFirebaseに存在・サンプル用の言葉をここで管理・'kind': 'sensitive'）
    {'text': '<不適切なワード>', 'kind': 'sensitive'},
  ];



  // リスト内に不適切なワードが含まれているかチェック
  for (var item in sensitiveWordsList) {
    if ((promptText.toLowerCase()).contains(item.toLowerCase())) {    // 小文字に変換してから判断
      return 'sensitive'; // 不適切な単語が含まれていれば 'sensitive' を返す
    }
  }

  // リスト内に指定された要素が含まれているかチェック
  for (var item in checkList) {
    if (item.containsKey('text') && item['text'] != null) {
      if (item.containsKey('kind') && item['kind'] != null) {
        // ---------------------------------- 種類：'goodbye' ---------------------------------
        if (item['kind'] == 'goodbye') {
          if (hiraganaToKatakana(promptText).contains(hiraganaToKatakana(item['text']!))) {
            return 'goodbye';
          } else if (item.containsKey('pronunciation') && item['pronunciation'] != null) {
            if (hiraganaToKatakana(promptText) == hiraganaToKatakana(item['pronunciation']!)) {
              return 'goodbye';
            }
          }
        }
        // -----------------------------------------------------------------------------------
        // --------------------------------- 種類：'idontknow' --------------------------------
        if (item['kind'] == 'idontknow') {
          if (hiraganaToKatakana(promptText).contains(hiraganaToKatakana(item['text']!))) {
            return 'idontknow';
          } else if (item.containsKey('pronunciation') && item['pronunciation'] != null) {
            if (hiraganaToKatakana(promptText).contains(hiraganaToKatakana(item['pronunciation']!))) {
              return 'idontknow';
            }
          }
        }
        // -----------------------------------------------------------------------------------
        // --------------------------------- 種類：'greeting' ---------------------------------
        if (item['kind'] == 'greeting') {
          if (hiraganaToKatakana(promptText).contains(hiraganaToKatakana(item['text']!))) {
            return 'greeting-${item['text']}';
          } else if (item.containsKey('pronunciation') && item['pronunciation'] != null) {
            if (hiraganaToKatakana(promptText) == hiraganaToKatakana(item['pronunciation']!)) {
              return 'greeting-${item['text']}';
            }
          }
        }
        // -----------------------------------------------------------------------------------
        // ----------------------------------- 種類：'game' -----------------------------------
        if (item['kind'] == 'game') {
          if (hiraganaToKatakana(promptText).contains(hiraganaToKatakana(item['text']!))) {
            return 'game';
          } else if (item.containsKey('pronunciation') && item['pronunciation'] != null) {
            if (hiraganaToKatakana(promptText) == hiraganaToKatakana(item['pronunciation']!)) {
              return 'game';
            }
          }
        }
        // -----------------------------------------------------------------------------------
        // ----------------------------------- 種類：'game' -----------------------------------
        // ----------------------------------- 種類：'sensitive' -----------------------------------
        if (item['kind'] == 'sensitive') {
          if (hiraganaToKatakana(promptText) == hiraganaToKatakana(item['text']!)) {
            return 'sensitive';
          } else if (item.containsKey('pronunciation') && item['pronunciation'] != null) {
            if (hiraganaToKatakana(promptText) == hiraganaToKatakana(item['pronunciation']!)) {
              return 'sensitive';
            }
          }
        }
        // -----------------------------------------------------------------------------------
      }
    }
  }

  // 意思を持って入力されたプロンプトかチェック
  if (promptText.length <= 1 ) {
    // プロンプトの文字数が1文字以下なら 'indifferent' を返す
    return 'indifferent';
  } else if (promptText.split('').every((char) => simbolList.contains(char))) {
    // すべての文字がsimbolListだったら 'indifferent' を返す
    return 'indifferent';
  }

  return 'true';
}
