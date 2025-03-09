import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:office_dx/components/common_sidebar_pages_appbar.dart';
import 'package:office_dx/components/page_title.dart';
import 'package:office_dx/pages/admin_page/admin_top_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';


double maxWidth = 500;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _inputtedEmail = '';
  String _inputtedPassword = '';
  String infoText = '';
  bool _isHovered = false;    // PW表示切替ゾーン ホバーしているかどうか

  // ------------------------  Firebase Authentication ------------------------
  @override
  void initState() {
    super.initState();
    initializeFirebase();
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      // Firebaseの初期化が成功した場合の処理
    } catch (e) {
      debugPrint('Firebase initializationでエラー：$e');
    }
  }

  // --------------------------------------------------------------------------

  // --------------------------  パスワード 表示/非表示 --------------------------
  bool _isDisplayPassword = false;
  void _changeIsDisplayPassword() {
    setState(() {
      _isDisplayPassword = !_isDisplayPassword;
    });
  }
  // --------------------------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonSidebarPagesAppbar(
        title: '管理者ログインページ',
        iconData: Icons.person_outlined
      ),
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
                PageTitle(
                  title: '管理者ログイン',
                  customColor: Color(0xFF0267B7),
                  subZone: Text(
                    '管理者用ページのため、学生はアクセスできません。',
                    style: TextStyle(color: Color(0xFF9FC7E7), fontWeight: FontWeight.w600, fontSize: 12)
                  )
                ),

                SizedBox(height: 15),

                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth - 30),
                  child: Column(children: [
                  // --------------------------------- エラーダイアログ ---------------------------------
                  (infoText=='ログインでエラーが発生')
                    ? Container(
                      constraints: BoxConstraints(maxWidth: maxWidth - 30),
                      padding: const EdgeInsets.fromLTRB(7, 10, 7, 10),
                      decoration: BoxDecoration(
                        color: Color(0xfffce6ef),
                        borderRadius: BorderRadius.circular(7)
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.error_outline_outlined, color: Colors.red),
                          SizedBox(width: 6),
                          Flexible(
                            flex: 10,
                            child: Text(
                              'ログインに失敗しました\n入力内容を確認の上、再度試行してください。',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)
                            ),
                          ),
                        ],
                      ),
                    )
                    : Text(''),
                  // -------------------------------------------------------------------------------

                  SizedBox(height: 15),

                  // ------------------------------------ Email ------------------------------------
                  Container(
                    constraints: BoxConstraints(maxWidth: maxWidth - 30),
                    height: 70,
                    child: TextField(
                      onChanged: (String value) {
                        setState(() {
                          _inputtedEmail = value;
                        });
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 3.0,
                          ),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                    ),
                  ),
                  // -------------------------------------------------------------------------------

                  SizedBox(height: 8),

                  // -------------------------------------- PW --------------------------------------
                  Container(
                    constraints: BoxConstraints(maxWidth: maxWidth - 30),
                    height: 70,
                    child: TextField(
                      obscureText: !_isDisplayPassword,
                      onChanged: (String value) {
                        setState(() {
                          _inputtedPassword = value;
                        });
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 3.0,
                          ),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                        // フィールド内右側の目のアイコン (スイッチ式に変更したためコメントアウト)
                        // suffixIcon: IconButton(
                        //   padding: const EdgeInsets.only(right: 3),
                        //   icon: Icon(
                        //     _isDisplayPassword ? Icons.visibility : Icons.visibility_off,
                        //     color: Color(0xFF0267B7),
                        //     size: 22
                        //   ),
                        //   onPressed: _changeIsDisplayPassword,
                        // ),
                      ),
                    ),
                  ),
                  // -------------------------------------------------------------------------------


                  // --------------------------- パスワード表示/非表示スイッチ --------------------------
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _isHovered = true; // マウスが入ったとき
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _isHovered = false; // マウスが出たとき
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: const Size(205, 34),
                          backgroundColor: _isHovered ? Color(0xfff4f4fd) : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: const EdgeInsets.all(0)
                        ),
                        onPressed: () => _changeIsDisplayPassword(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('パスワードを表示する', style: TextStyle(fontSize: 12, color: Color(0xff005a8f), fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 15,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    activeTrackColor: Color(0xFF0267B7),
                                    value: _isDisplayPassword,
                                    onChanged: (value) => _changeIsDisplayPassword(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // -------------------------------------------------------------------------------

                  SizedBox(height: 40),

                  // --------------------------------- ログインボタン ---------------------------------
                  SizedBox(
                    height: 58,
                    width: 280,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: SizedBox(
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const  [
                                    SizedBox(height: 10),
                                    SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
                                    SizedBox(height: 30),
                                    Text('ログイン試行中', style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            );
                          }
                        );
                        try {
                          setState(() {
                            infoText = 'ログイン中';
                          });
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final UserCredential result = await auth.signInWithEmailAndPassword(
                            email: _inputtedEmail,
                            password: _inputtedPassword,
                          );
                          final User user = result.user!;
                          setState(() {
                            infoText = "ログインに成功しました。ログインメールアドレスは${user.email}です";
                          });
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminTopPage(), fullscreenDialog: true)
                          );
                        } catch (e) {
                          setState(() {
                            infoText = 'ログインでエラーが発生';
                          });
                          debugPrint('infoTextは、$infoText');
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      ),
                      child: const Text(
                        'ログイン',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  ),

                  // ログイン後の画面にログインなしで画面遷移(⚠️開発用)
                  SizedBox(height: 100),
                  TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        backgroundColor: Color(0xffffe2fd),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminTopPage())
                        );
                      },
                      child: AutoSizeText(
                        'ログイン後の画面に遷移(⚠️デモ用) →',
                        style: TextStyle(color: Color(0xfff00a96), fontSize: 17
                      ),)
                    ),
                  // -------------------------------------------------------------------------------
                  ])
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

