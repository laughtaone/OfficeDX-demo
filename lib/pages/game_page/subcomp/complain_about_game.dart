import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';




class ComplainAboutGame extends StatefulWidget {
  const ComplainAboutGame({super.key,
  });

  // final void Function(int) argCurrentPage;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<ComplainAboutGame> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // タイマーの初期設定
    _startTimer();
  }

  @override
  void dispose() {
    // タイマーのキャンセル
    _timer?.cancel();
    super.dispose();
  }

  // --------------------- 関数 ---------------------
  // タイマーのスタート
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  // ページ変更時にタイマーをリセット
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    // タイマーが存在している場合はキャンセルして再スタート
    _timer?.cancel();
    _startTimer();
  }
  // -----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              ruleTile(columnChildren: [
                ruleTitle('ルール 1'),
                SizedBox(height: 6),
                ruleText('たくさん出てくる文字の中から'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ruleText('産技高専'),
                  ),
                  ruleText('or'),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ruleText('TMCIT'),
                  ),
                ]),
                SizedBox(height: 6),
                ruleText('を探して選べ！'),
              ]),

              ruleTile(columnChildren: [
                ruleTitle('ルール 2'),
                SizedBox(height: 6),
                ruleText('1個正しく選ぶごとに1スコアゲット！'),
                ruleText('制限時間は30秒！'),
                ruleText('ハイスコアを目指せ！'),
                ruleText('（押し間違えてもスコアは減りません）', customTextSize: 16),
              ]),
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          circleContainer(isPainted: (_currentPage == 0)),
          circleContainer(isPainted: (_currentPage == 1)),
        ]),
        SizedBox(height: 20),
      ],
    );
  }
}


Padding ruleTile({required List<Widget> columnChildren}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: columnChildren
    ),
  );
}

Text ruleTitle(String title) {
  return Text(title, style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold));
}

Padding ruleText(String text, {double customTextSize = 20}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: AutoSizeText(text, maxFontSize: customTextSize, style: TextStyle(fontWeight: FontWeight.w500), textAlign: TextAlign.center),
  );
}

Container circleContainer({required bool isPainted}) {
  return Container(
    width: 8,
    height: 8,
    margin: EdgeInsets.symmetric(horizontal: 3),
    decoration: BoxDecoration(
      color: (isPainted) ? Colors.black : Color(0xffD0D0D0), // 黒色
      shape: BoxShape.circle, // 円形に設定
    ),
  );
}
