// 指定した範囲内でランダムに遅延する関数


import 'dart:async';
import 'dart:math';

Future<void> functionLoadingRandomSeconds({
  required int minMilliseconds,
  required int maxMilliseconds
}) async {
  minMilliseconds = minMilliseconds.abs();
  maxMilliseconds = maxMilliseconds.abs();

  // ランダムな遅延時間を生成
  Random random = Random();
  int delayMilliseconds = minMilliseconds + (random.nextInt(maxMilliseconds - minMilliseconds)).abs();


  // ランダムに生成した遅延時間で待機
  await Future.delayed(Duration(milliseconds: delayMilliseconds));
}