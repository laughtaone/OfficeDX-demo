// ゲームのハイスコア値の読込・書込・削除を行う関数
/* 使用例(取得する場合)
int? getHighScoreInt = await loadHighScore();
これにより、ハイスコアがある場合はその値が取得でき、ない場合はnullになる
*/


import 'package:shared_preferences/shared_preferences.dart';



// 設定値を読み込む
Future<int?> loadHighScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('game_high_score');
}

// 設定値を書き込む
Future<void> writeHighScore({required int writeInt}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('game_high_score', writeInt);
}

// 設定値を削除する
Future<void> deleteHighScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('game_high_score');
}