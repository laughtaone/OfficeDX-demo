// 設定した値の読み込みを行う関数


import 'package:shared_preferences/shared_preferences.dart';




// トップ画面 学校名ボタン表示するかどうかの真偽値を読み込む
Future<bool?> loadIsNotDisplaySchoolName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('settings_isNotDisplaySchoolName');
}

// トップ画面 チャットボタン表示するかどうかの真偽値を読み込む
Future<bool?> loadIsNotDisplayChatButton() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('settings_isNotDisplayChatButton');
}

// チャット画面 あいさつ機能を消すどうかの真偽値を読み込む
Future<bool?> loadIsNotDisplayGreeting() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('settings_isNotDisplayGreeting');
}

// チャット画面 チャット終了誘導機能を消すどうかの真偽値を読み込む
Future<bool?> loadIsNotDisplayEndChat() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('settings_isNotDisplayEndChat');
}

// チャット画面 ミニゲームを表示するかどうかの真偽値を読み込む
Future<bool?> loadIsNotDisplayMiniGame() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('settings_isNotDisplayMiniGame');
}
