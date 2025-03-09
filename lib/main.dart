import 'package:flutter/material.dart';
import 'package:office_dx/components/common_bottombar.dart';
import 'package:office_dx/components/common_appbar.dart';
import 'package:office_dx/components/chat_button.dart';
import 'package:office_dx/functions/shared_preferences/function_get_settings.dart';
import 'package:office_dx/pages/3_bottom_tabs/home_page.dart';
import 'package:office_dx/pages/3_bottom_tabs/application_page.dart';
import 'package:office_dx/pages/3_bottom_tabs/qna_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:office_dx/firebase_options.dart';
import 'package:office_dx/pages/chat_page/chat_page.dart';
import 'package:office_dx/components/side_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint(".envの読み込みでエラー：$e");
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initializationでエラー：$e");
  }
  runApp(OfficeDX());
}


class OfficeDX extends StatelessWidget {
  const OfficeDX({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '電子窓口',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoJP',
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0267B7), // 主要な色
          secondary: Color(0xFF9FC7E7), // セカンダリ色
          surface: Color(0xFF0267B7), // 表面色
          error: Colors.red, // エラー色
          onPrimary: Colors.white, // 主要な色の上でのテキスト色
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onError: Colors.red, // エラー色の上でのテキスト色
          brightness: Brightness.light, // 明るさ
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(title: '電子窓口'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 1;
  bool isNotDisplaySchoolName = false;
  bool isNotDisplayChatButton = false;

  // タブごとのページをここで定義
  List<Widget> pages = [
    ApplicationPage(),
    HomePage(),
    QnAPage(),
  ];

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    bool keepIsNotDisplaySchoolName = await loadIsNotDisplaySchoolName() ?? false;
    bool keepIsNotDisplayChatButton = await loadIsNotDisplayChatButton() ?? false;
    setState(() {
      isNotDisplaySchoolName = keepIsNotDisplaySchoolName;
      isNotDisplayChatButton = keepIsNotDisplayChatButton;
      if (pages.length == 3 && pages[1] is HomePage) {
        pages[1] = HomePage(isNotDisplaySchoolName: isNotDisplaySchoolName);
      }

      // 再確認(バグ対策)
      if (pages.length != 3 && pages[1].runtimeType != HomePage) {
        pages = [
          ApplicationPage(),
          HomePage(),
          QnAPage(),
        ];
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(isNotDisplaySchoolName: isNotDisplaySchoolName),
      endDrawer: SideBar(
        isNotDisplaySchoolName: isNotDisplaySchoolName,
        argOpenedSettingsPage: (bool recvBool) async {
          if (recvBool) {
            loadSettings();
          }
        },
      ),
      body: pages[pageIndex],
      bottomNavigationBar: CommonBottombar(
        onTap: (v) => setState(() {
          pageIndex = v;
        }),
      ),
      floatingActionButton: (!isNotDisplayChatButton)
        ? ChatButton(
          customOpacity: (pageIndex != 1) ? 0.7 : 1,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(),
                fullscreenDialog: true
              ),
            );
          }
        )
        : null
    );
  }
}
