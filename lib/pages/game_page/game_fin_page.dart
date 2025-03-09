import 'package:flutter/material.dart';
import 'package:office_dx/pages/game_page/subcomp/subcomp_appbar_game.dart';
import 'package:office_dx/functions/shared_preferences/function_get_game_highscore.dart';
import 'package:office_dx/pages/game_page/game_top_page.dart';




class GameFinPage extends StatefulWidget {
  const GameFinPage({super.key,
    required this.scoreInt
  });

  final int scoreInt;

  @override
  State<GameFinPage> createState() => SearchPageState();
}

class SearchPageState extends State<GameFinPage> {
  // =============================================== 変数 ===================================================
  int? oldHighScoreInt;
  bool isHighScore = false;
  // =======================================================================================================

  // ==========================================  使用する関数類 ==============================================
  @override
  void initState() {
    super.initState();
    _setupHighScore();
  }

  Future<void> _setupHighScore() async {
    int? getHighScoreInt = await loadHighScore();

    if (getHighScoreInt != null) {
      if (widget.scoreInt > getHighScoreInt) {
        await writeHighScore(writeInt: widget.scoreInt);
        setState(() {
          isHighScore = true;
          oldHighScoreInt = getHighScoreInt;
        });
      } else {
        setState(() {
          oldHighScoreInt = getHighScoreInt;
        });
      }
    } else {
      await writeHighScore(writeInt: widget.scoreInt);
      setState(() {
        isHighScore = true;
        oldHighScoreInt = getHighScoreInt;
      });
    }
  }
  // =======================================================================================================


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double maxWidth = (screenWidth < 800) ? 600 : 700;      // スマホの幅を800px未満/デスクトップはそれ以上と定義

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
      child: Scaffold(
        backgroundColor: backColor,
        appBar: subcompAppbarGame(
          customWidth: maxWidth,
          backColor: backColor,
          onPressedClose: () {
            Navigator.pop(context);
          }
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final appBarHeight = kToolbarHeight;
            final bottomNavBarHeight = kBottomNavigationBarHeight;
            final bodyHeight = constraints.maxHeight - appBarHeight - bottomNavBarHeight;

            return SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Center(
                child: Container(
                  height: bodyHeight,
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    // ---------------------------------- タイトル ---------------------------------
                    Text(
                      '🎯\n結果',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                      textAlign: TextAlign.center
                    ),
                    // ------------------------------------------------------------------------------

                    // ---------------------------------- スコア表示 ---------------------------------
                    Column(children: [
                      (isHighScore)
                        ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            // color: Color(0xfff9f8e6),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text('最高スコアを更新！', style: TextStyle(color: Color(0xfff18e22), fontWeight: FontWeight.w700, fontSize: 22))
                        )
                        : SizedBox.shrink(),

                      SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 70),
                        decoration: BoxDecoration(
                          color: Color(0xfffefbf1)
                        ),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                              Text('スコア', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                              Text(widget.scoreInt.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                            ]),
                            SizedBox(height: 5),
                            (oldHighScoreInt != null)
                              ? Text(
                                (isHighScore)
                                  ? '（あなたの前の最高スコア：${oldHighScoreInt.toString()}）'
                                  : '（あなたの最高スコア：${oldHighScoreInt.toString()}）',
                                style: TextStyle(fontWeight: FontWeight.w500,  fontSize: 16),
                              )
                              : SizedBox.shrink()
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.error_outline_outlined, size: 18),
                        SizedBox(width: 5),
                        Text('表示される最高スコアはご自身の中での最高値です', style: TextStyle(fontSize: 13),)
                      ]),

                      SizedBox(height: 10),
                    ]),
                    // ------------------------------------------------------------------------------

                    // ----------------------------- 最初の画面へ戻るボタン -----------------------------
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        overlayColor: Color(0xff766627),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                        )
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('< 最初の画面へ', style: TextStyle(fontSize: 30, color: mainColor))
                    ),
                    // ------------------------------------------------------------------------------
                  ])
                )
              ),
            );
          }
        )
      ),
    );
  }
}


Color backColor = Color(0xfff6f3e4);