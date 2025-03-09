import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:office_dx/pages/game_page/game_fin_page.dart';
import 'package:office_dx/pages/game_page/game_top_page.dart';
import 'package:office_dx/pages/game_page/subcomp/subcomp_appbar_game.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';

class GamePlayPage extends StatefulWidget {
  const GamePlayPage({super.key});

  @override
  State<GamePlayPage> createState() => SearchPageState();
}

class SearchPageState extends State<GamePlayPage> {
  // =============================================== 変数 ===================================================
  int scoreInt = 0;
  bool? isAnswer;
  List<String> qList = [];
  int timeCounter = -3;
  late Timer _timer;
  bool isFinish = false;
  bool isPaused = false;
  bool isStart = false;
  Timer? _answerTimer; // 新しいタイマーを追加
  // =======================================================================================================

  // =========================================== 使用する関数類 ==============================================
  @override
  void initState() {
    super.initState();

    setState(() {
      qList = listSetup(isSangi: true);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!isPaused) {
          setState(() {
            timeCounter++;
          });
        }

        if (timeCounter == 0) {
          setState(() {
            isStart = true;
          });
        }

        // 30秒経過したらタイマーを停止
        if (timeCounter >= 30) {
          setState(() {
            isFinish = true;
          });
        }

        // 34秒(終了後4秒)経過したら完了画面に遷移
        if (timeCounter >= 33) {
          _timer.cancel();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameFinPage(scoreInt: scoreInt)),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // タイマーをキャンセルしてメモリリークを防ぐ
    _answerTimer?.cancel(); // 新しいタイマーもキャンセル
    super.dispose();
  }

  bool checkAnswer(String pressedText) {
    if (pressedText == '産技高専' || pressedText == 'TMCIT') {
      setState(() {
        isAnswer = true;
      });
      _startAnswerTimer(); // タイマーを開始
      return true;
    }
    setState(() {
      isAnswer = false;
    });
    _startAnswerTimer(); // タイマーを開始
    return false;
  }

  void _startAnswerTimer() {
    _answerTimer?.cancel(); // 既存のタイマーをキャンセル
    _answerTimer = Timer(Duration(milliseconds: 1250), () {
      setState(() {
        isAnswer = null; // 3秒後にisAnswerをnullにリセット
      });
    });
  }

  void jumpNextQuestion() {
    setState(() {
      scoreInt++;
      qList = listSetup(isSangi: (scoreInt % 2 == 0));
    });
  }

  List<String> listSetup({required bool isSangi}) {
    List<String> sangiList = [
      '産技高専',
      '産業高専',
      '技術高専',
      '産業学園',
      '産業学院',
      '産学高専',
      '産技中学',
      '産技高校',
      '産技大学',
      '彦扙高専',
      '産技高揚',
      '産技高技',
      '産技高接'
    ];
    List<String> tmcitList = [
      'TMCIT',
      'TMCIL',
      'TNCIT',
      'TWCIT',
      'TMC1T',
      'TMLIT',
      'YMCIT',
      'TMCIY',
      'TMCIA',
      'TMCTT',
      'TMXIT',
      'TMCAT',
      'TMNIT',
      'TICMT',
    ];
    final random = Random();
    final List<String> shuffledList = List.from((isSangi) ? sangiList : tmcitList);

    for (int i = shuffledList.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffledList[i];
      shuffledList[i] = shuffledList[j];
      shuffledList[j] = temp;
    }

    return shuffledList;
  }
  // =======================================================================================================

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 画面の幅を取得
    double maxWidth = (screenWidth < 800) ? 600 : 700; // スマホの幅を800px未満/デスクトップはそれ以上と定義

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
      child: Scaffold(
        backgroundColor: (isFinish)
            ? completedColor
            : (isStart)
                ? Colors.white
                : startBackColor,
        appBar: subcompAppbarGame(
          backColor: backColor,
          customWidth: maxWidth,
          onPressedClose: () {
            isPaused = true;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    contentPadding: const EdgeInsets.fromLTRB(26, 10, 26, 10),
                    title: Text('確認'),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('本当に中断しますか？',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center),
                        SizedBox(height: 25),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: mainColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 20)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            isPaused = false;
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'キャンセル',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                );
              },
            ).then((_) {
              // ダイアログ外をタップして閉じた場合にも対処
              if (isPaused) {
                isPaused = false;
              }
            });
          },
          leftWidget: Column(children: [
            Text('スコア', style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text(scoreInt.toString(),
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))
          ]),
          centerWidget: Column(children: [
            Text('残り時間', style: TextStyle(fontSize: 12)),
            Text(
                (timeCounter < 0 || timeCounter > 30)
                    ? 'ー'
                    : '${30 - timeCounter}s',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))
          ]),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          // ----------------------- 変数類 -----------------------
          // final bottomNavBarHeight = kBottomNavigationBarHeight;
          final bodyHeight = constraints.maxHeight;
          final double heightSearchWordInfo = 50;
          final double heightIsAnswerInfo = 65;
          final double heightGapWordItem = 12;
          final double bottomPadding = 25;
          final double buttonHeight = (bodyHeight - heightIsAnswerInfo - heightSearchWordInfo - heightGapWordItem * 6 - bottomPadding) / 7;
          // ----------------------------------------------------

          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  // ---------------------------------- 探す言葉 表示 ----------------------------------
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backColor2,
                    ),
                    child: Center(
                      child: Container(
                        width: maxWidth,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(Icons.search, size: 20),
                                  ),
                                  AutoSizeText(
                                    '探す言葉',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    maxFontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                (isFinish || !isStart)
                                    ? 'ー'
                                    : (scoreInt % 2 == 0)
                                        ? '産技高専'
                                        : 'TMCIT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ---------------------------------------------------------------------------------
                  Container(
                    height: bodyHeight - heightSearchWordInfo,
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // -------------------------------- 正解/不正解 表示 ---------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          margin: const EdgeInsets.only(bottom: 20),
                          height: heightIsAnswerInfo - 20,
                          decoration: BoxDecoration(
                            color: (isFinish)
                              ? completedColor
                              : (isStart)
                                ? (isAnswer != null)
                                  ? (isAnswer!)
                                    ? Color(0xfff9e6e6)
                                    : Color(0xffedf0f8)
                                  : null
                                : startBackColor,
                          ),
                          child: Center(
                            child: Text(
                              (isFinish || !isStart)
                                ? ''
                                : isAnswer != null
                                  ? (isAnswer!)
                                    ? '正解'
                                    : '不正解'
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: (isAnswer != null)
                                  ? (isAnswer!)
                                    ? Color(0xffe14e47)
                                    : Color(0xff4758e1)
                                  : null
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // ---------------------------------------------------------------------------------


                        // ------------------------------------ 言葉ボタン -----------------------------------
                        (!isStart)
                          // - - - - - - - - 開始時のカウント表示  - - - - - - - -
                          ? Center(
                            child: Text(
                              '開始まで\n${-timeCounter}',
                              style: TextStyle(color: Color(0xffaf36bf), fontSize: 45, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                          // - - - - - - - - - - - - - - - - - - - - - - - - -
                          : (isFinish)
                            // - - - - - - - - - - 終了時の表示 - - - - - - - - - -
                            ? Text(
                              '終了',
                              style: TextStyle(color: Color(0xff2ed661), fontSize: 50, fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.center
                            )
                            // - - - - - - - - - - - - - - - - - - - - - - - - -
                            : Expanded(
                              child: SizedBox(
                                height: bodyHeight - heightSearchWordInfo - heightIsAnswerInfo,
                                child: GridView(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10, // アイテム間の横のスペース
                                    mainAxisSpacing: heightGapWordItem, // アイテム間の縦のスペース
                                    mainAxisExtent: (buttonHeight <= 80) ? buttonHeight : 80,
                                  ),
                                  children: qList.map((label) {
                                    return TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        backgroundColor: backColor2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (checkAnswer(label)) {
                                          jumpNextQuestion();
                                        }
                                      },
                                      child: AutoSizeText(
                                        (isFinish) ? 'ー' : label,
                                        style: TextStyle(
                                          fontSize: 23,
                                          color: Colors.black
                                        )
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        // ---------------------------------------------------------------------------------

                        SizedBox(height: bottomPadding)
                      ]),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

Color backColor = Color(0xfff6f3e4);
Color backColor2 = Color(0xfffaf8f0);
Color completedColor = Color(0xffe6f9ee);
Color startBackColor = Color(0xfffbedfc);