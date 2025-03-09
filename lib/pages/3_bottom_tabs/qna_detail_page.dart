import 'package:flutter/material.dart';
import 'package:office_dx/components/qna_detail_comp.dart';
import 'package:office_dx/functions/function_loading_random_seconds.dart';



double maxWidth = 600;

class QaDetailPage extends StatefulWidget {
  const QaDetailPage({super.key,
    required this.createdAt,
    required this.question,
    required this.answer,
    required this.categoryName,
    required this.updatedAt,
    this.displayLoadMark = false
  });

  final String createdAt;
  final String question;
  final String answer;
  final String categoryName;
  final String updatedAt;
  final bool displayLoadMark;

  @override
  State<QaDetailPage> createState() => QaDetailPageState();
}

class QaDetailPageState extends State<QaDetailPage> {
  late bool displayLoadMark;

  @override
  void initState() {
    super.initState();
    displayLoadMark = widget.displayLoadMark;

    if (displayLoadMark) {
      changeLoadMark();
    }
  }

  Future<void> changeLoadMark() async{
    await functionLoadingRandomSeconds(minMilliseconds: 300, maxMilliseconds: 600);

    setState(() {
      displayLoadMark = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('質問：${widget.question}', style: TextStyle(color: Colors.white, fontSize: 18), overflow: TextOverflow.ellipsis,),
        actions: [IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, color: Colors.white, size: 30)
        )],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: (displayLoadMark)
              // ------------------- displayLoadMarkがtrueのとき読み込みマーク表示 -------------------
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
                  SizedBox(height: 20),
                  Text('読込中...', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20))
                ],
              )
              // ---------------------------------------------------------------------------------

              // ---------------------------- 読み込み完了後のQ&A内容表示 ----------------------------
              : Column(
                children: [
                  const SizedBox(height: 20),
                  QNADetailComp(
                    createdAt: widget.createdAt,
                    question: widget.question,
                    answer: widget.answer,
                    categoryName: widget.categoryName,
                    updatedAt: widget.updatedAt,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              // ---------------------------------------------------------------------------------
          ),
        ),
      )
    );
  }
}
