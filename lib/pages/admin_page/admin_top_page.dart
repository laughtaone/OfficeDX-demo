import 'package:flutter/material.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:office_dx/demo_components/demo_caution.dart';
import 'package:office_dx/pages/admin_page/manage_document/manage_document.dart';
import 'package:office_dx/pages/admin_page/manage_qa/manage_qa.dart';



double maxWidth = 450;


class AdminTopPage extends StatefulWidget {
  const AdminTopPage({super.key});

  @override
  State<AdminTopPage> createState() => LoginPageState();
}

class LoginPageState extends State<AdminTopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------------------------- AppBar -----------------------------
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('管理者ページ', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff568bf7),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text('確認'),
                    content: Text('本当にログアウトしますか？', style: TextStyle(fontSize: 17)),
                    actions: [
                      TextButton(
                        child: Text("OK", style: TextStyle(fontSize: 17)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      ),
                      TextButton(
                        child: Text("キャンセル", style: TextStyle(color: Colors.red, fontSize: 17)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              );
              // Navigator.pop(context);
            },
            child: Opacity(
              opacity: 0.8,
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                margin: const EdgeInsets.only(top: 7, bottom: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Row(children: [
                  Icon(Icons.logout_outlined, size: 17),
                  SizedBox(width: 2),
                  Text('ログアウト')
                ]),
              ),
            ))
        ],
      ),
      // -------------------------------------------------------------------
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          height: 1000,
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),

                // ----------------------------- タイトル -----------------------------
                SizedBox(width: maxWidth+300, child: PageTitle(title: '管理項目を選択', customColor: Color(0xFF0267B7))),
                // -------------------------------------------------------------------

                // ---------------- デモ用警告 ----------------
                SizedBox(height: 15),
                DemoCaution(
                  customMessage: 'デモ版のため内容は反映されませんが\n操作を体験することはできます',
                  isHeightFixed: false,
                  customWidth: maxWidth,
                ),
                // -------------------------------------------

                SizedBox(height: 20),

                // --------------------------- 管理項目選択 ----------------------------
                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: ManagementItemTile(
                    icon: Icons.description_outlined,
                    itemName: '掲載書類',
                    jumpPage: ManageDocumentPage(),
                  ),
                ),

                SizedBox(height: 15),

                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: ManagementItemTile(
                    icon: Icons.question_answer_outlined,
                    itemName: 'Q&A',
                    jumpPage: ManageQaPage(),
                  ),
                ),
                // -------------------------------------------------------------------
              ],
            )
          ),
        ),
      ),
    );
  }
}











class ManagementItemTile extends StatelessWidget {
  const ManagementItemTile({
    super.key,
    required this.icon,
    required this.itemName,
    required this.jumpPage
  });

  final IconData icon;
  final String itemName;
  final Widget jumpPage;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => jumpPage, fullscreenDialog: true),
        );
      },
      style: TextButton.styleFrom(
        fixedSize: Size(double.infinity, 90),
        backgroundColor: Color(0xffe2e9ff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.only(top: 2), height: double.infinity, child: Icon(icon)),
          SizedBox(width: 7),
          SizedBox(height: double.infinity, child: Center(child: Text(itemName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)))),
          SizedBox(width: 20),
          Container(padding: const EdgeInsets.only(top: 2), height: double.infinity, child: Icon(Icons.arrow_forward_ios, size: 20))
        ],
      )
    );
  }
}
