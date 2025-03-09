import 'package:flutter/material.dart';
import 'package:office_dx/components/common_appbar.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:office_dx/components/container_border_radius.dart';
import 'package:office_dx/components/dialog_ok_only.dart';


double maxWidth = 550;


class FormPage extends StatefulWidget {
  const FormPage({super.key});


  @override
  State<FormPage> createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  String inputtedEmail = '';
  String inputtedQuestion = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              const SizedBox(height: 30),

              // --------------------------- ページタイトル ---------------------------
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth+100),
                child: PageTitle(title: "質問・お問い合わせ")
              ),
              // -------------------------------------------------------------------

              const SizedBox(height: 16),

              // ------------------------ Email入力フィールド -------------------------
              SizedBox(
                width: 350,
                height: 50,
                child: TextField(
                  onChanged: (String newEmail) {
                    setState(() {
                      inputtedEmail = newEmail;
                    });
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    filled: false,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    hintText: "Email",
                  ),
                )
              ),
              // -------------------------------------------------------------------

              const SizedBox(height: 16),

              // ------------------------ 質問内容入力フィールド -----------------------
              SizedBox(
                width: 350,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  maxLength: 1500,
                  controller: questionController,
                  onChanged: (String newQuesiton) {
                    setState(() {
                      inputtedQuestion = newQuesiton;
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    filled: false,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                    hintText: "質問・お問い合わせ内容",
                  ),
                )
              ),
              // -------------------------------------------------------------------

              const SizedBox(height: 32),

              // ---------------------------- 送信ボタン -----------------------------
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60), elevation: 2,
                  backgroundColor: Theme.of(context).primaryColor,
                  disabledBackgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2)
                ),
                onPressed: (inputtedEmail.isEmpty || inputtedQuestion.isEmpty)
                  ? null
                  : () {
                    // -  -  -  -  -  -  - 確認ダイアログ -  -  -  -  -  -  -  -
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: Color(0xffeaf0f8),
                          title: Text('確認'),
                          content: SizedBox(
                            height: 370,
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('次の内容で送信されます。\nよろしいですか？', style: TextStyle(fontSize: 15)),
                                SizedBox(height: 10),

                                Expanded(
                                  child: Scrollbar(
                                    controller: _scrollController,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          // ------------------ Email ------------------
                                          subtitleLocalComp(recvText: 'Email'),
                                          containerBorderRadius(
                                            customWidth: double.infinity,
                                            child: Text(
                                              inputtedEmail,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          // -------------------------------------------

                                          SizedBox(height: 22),

                                          // ----------------- 質問内容 -----------------
                                          subtitleLocalComp(recvText: '質問内容'),
                                          containerBorderRadius(
                                            customWidth: double.infinity,
                                            child: Text(
                                              inputtedQuestion,
                                            ),
                                          ),
                                          // -------------------------------------------
                                        ]),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text("OK", style: TextStyle(fontSize: 17)),
                              ),
                              // -  -  -  -  -  - 未実装案内 -  -  -  -  -  -  -  -
                              onPressed: () {
                                dialogOkOnly(
                                  dialogText: '未実装の機能のため\n送信せずに閉じます',
                                  context: context,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                );
                              }
                              // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
                            ),
                            TextButton(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                                child: Text("キャンセル", style: TextStyle(color: Colors.red, fontSize: 17)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                    );
                    // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
                  },
                child: const Text(
                  "送信する",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              )
              // -------------------------------------------------------------------
            ]),
          ),
        )
      )
    );
  }
}




// ============= 各部分のスタイルを以下で一括指定 =============
Padding subtitleLocalComp({required String recvText, bool mini = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      recvText,
      overflow: TextOverflow.clip,
      maxLines: 1,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: (!mini) ?19 :17)
    )
  );
}

Padding explainTextLocalComp(recvText) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      recvText,
      style: TextStyle(fontSize: 13, color: Color(0xff222222))
    ),
  );
}
