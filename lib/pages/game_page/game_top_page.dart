import 'package:flutter/material.dart';
import 'package:office_dx/functions/shared_preferences/function_get_game_highscore.dart';
import 'package:office_dx/functions/function_loading_random_seconds.dart';
import 'package:office_dx/pages/game_page/game_play_page.dart';
import 'package:office_dx/pages/game_page/subcomp/complain_about_game.dart';
import 'package:office_dx/pages/game_page/subcomp/subcomp_appbar_game.dart';



class GameTopPage extends StatefulWidget {
  const GameTopPage({super.key,
  });

  @override
  State<GameTopPage> createState() => SearchPageState();
}

class SearchPageState extends State<GameTopPage> {
  bool isFirstLoad = false;

  @override
  void initState() {
    super.initState();
    changeIsFirstLoad();
  }

  Future<void> changeIsFirstLoad() async{
    await functionLoadingRandomSeconds(minMilliseconds: 1200, maxMilliseconds: 1600);

    setState(() {
      isFirstLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double maxWidth = (screenWidth < 800) ? 600 : 700;      // スマホの幅を800px未満・デスクトップはそれ以上と定義

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
      child: Scaffold(
        backgroundColor: backColor,
        appBar: subcompAppbarGame(
          backColor: backColor,
          customWidth: maxWidth,
          onPressedClose: () => Navigator.pop(context),
          // ----------------------------- ハイスコアリセット -----------------------------
          leftWidget: IconButton(
            onPressed: () async {
              int? getHighScoreInt = await loadHighScore();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    contentPadding: const EdgeInsets.fromLTRB(26, 10, 26, 10),
                    title: Text('ハイスコアのリセット'),
                    content: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(height: 5),
                      Text('ハイスコアをリセットしますか？', style: TextStyle(fontSize: 17), textAlign: TextAlign.center),
                      SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xfff0f0f0),
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('あなたのハイスコア'),
                            SizedBox(width: 20),
                            Flexible(child: Text(
                              (getHighScoreInt != null) ? getHighScoreInt.toString() : 'なし',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 20)
                        ),
                        onPressed: () {
                          deleteHighScore();
                          Navigator.of(context).pop();
                        },
                        child: Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('キャンセル', style: TextStyle(color: Colors.red, fontSize: 14),)
                      ),
                      SizedBox(height: 5),
                    ]),
                  );
                }
              );
            },
            icon: Icon(Icons.manage_history_outlined)
          )
          // ---------------------------------------------------------------------------
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bottomNavBarHeight = kBottomNavigationBarHeight;
            final bodyHeight = constraints.maxHeight - bottomNavBarHeight;

            return SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Center(
                child: Container(
                  height: bodyHeight,
                  constraints: BoxConstraints(
                    maxWidth: maxWidth
                  ),
                  child: (!isFirstLoad)
                    // ----------------------------- 準備中の場合の表示 -----------------------------
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 65, width: 65, child: CircularProgressIndicator(color: mainColor)),
                          SizedBox(height: 20),
                          Text('準備中...', style: TextStyle(color: mainColor, fontSize: 20))
                        ],
                      )
                    // ---------------------------------------------------------------------------
                    // ------------------------------ 準備完了後の表示 ------------------------------
                    : Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('🎮', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: mainColor)),
                          Text('ミニゲーム', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55, color: mainColor)),
                        ]),

                        Container(
                          height: 270,
                          decoration: BoxDecoration(
                            color: Color(0xfffefbf1),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: ComplainAboutGame()
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                              backgroundColor: mainColor,
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              shadowColor: Colors.black,
                              elevation: 12,
                              ),
                              onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GamePlayPage()),
                              );
                              },
                              child: Text('スタート >', style: TextStyle(fontSize: 30, color: Colors.white))
                            ),
                            SizedBox(height: 20),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.error_outline_outlined, color: Color(0xff707070)),
                              SizedBox(width: 10),
                              Text('授業中や勤務中のプレイはご遠慮ください', style: TextStyle(color: Color(0xff707070)))
                            ]),
                          ],
                        ),
                      ])
                      // ---------------------------------------------------------------------------
                    ),
              ),
            );
          }
        )
      ),
    );
  }
}


Color backColor = Color(0xffFFF8E1);
Color mainColor = Color(0xff9d433f);
