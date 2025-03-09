import 'package:flutter/material.dart';
import 'package:office_dx/pages/settings_page/use_packages_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:office_dx/components/common_sidebar_pages_appbar.dart';

double maxWidth = 550;


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}


class SettingsPageState extends State<SettingsPage> {
  // ==========================================  使用する関数類 ==============================================
  late SharedPreferences prefs;
  late bool isNotDisplaySchoolName;
  late bool isNotDisplayChatButton;
  late bool isNotDisplayGreeting;
  late bool isNotDisplayEndChat;
  late bool isNotDisplayMiniGame;
  // =======================================================================================================

  // ==========================================  使用する関数類 ==============================================
  @override
  void initState() {
    super.initState();
    firstLoad();
  }

  void firstLoad() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotDisplaySchoolName = prefs.getBool('settings_isNotDisplaySchoolName') ?? false;
      isNotDisplayChatButton = prefs.getBool('settings_isNotDisplayChatButton') ?? false;
      isNotDisplayGreeting = prefs.getBool('settings_isNotDisplayGreeting') ?? false;
      isNotDisplayEndChat = prefs.getBool('settings_isNotDisplayEndChat') ?? false;
      isNotDisplayMiniGame = prefs.getBool('settings_isNotDisplayMiniGame') ?? false;
    });
  }
  // =======================================================================================================


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;     // 画面の幅を取得
    double maxWidth = (screenWidth < 800) ? 500 : 600;
    double settingsWidgetWidth = 500;
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(), // ダイアログ外をタップするとキーボードを閉じる
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F7),
        appBar: CommonSidebarPagesAppbar(
          title: '設定',
          iconData: Icons.settings_outlined
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: (screenWidth > settingsWidgetWidth)
              ? ((screenWidth - settingsWidgetWidth) ~/ 2).toDouble()
              : 0
          ),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (settingsWidgetWidth != constraints.maxWidth) {
                  settingsWidgetWidth = constraints.maxWidth;
                }
                return SettingsList(
                  platform: DevicePlatform.iOS,
                  sections: [
                    // ------------------------------ トップ画面の設定 ------------------------------
                    SettingsSection(
                      title: Text('トップ画面'),
                      tiles: [
                        // - - - - - - - - 学校名非表示 - - - - - - - -
                        SettingsTile.switchTile(
                          leading: Icon(Icons.school_outlined),
                          title: const Text('学校名を非表示'),
                          initialValue: isNotDisplaySchoolName,
                          onToggle: (value) async {
                            await prefs.setBool('settings_isNotDisplaySchoolName', value);
                            bool subBool = prefs.getBool('settings_isNotDisplaySchoolName') ?? value;
                            setState(() {
                              isNotDisplaySchoolName = subBool;
                            });
                          },
                        ),
                        // - - - - - - - - - - - - - - - - - - - - - -
                        // - - - - - - - - 学校名非表示 - - - - - - - -
                        SettingsTile.switchTile(
                          leading: Icon(Icons.chat_outlined),
                          title: const Text('チャットボタンを非表示'),
                          description: Text('このスイッチをオフで表示・オンで非表示になります'),
                          initialValue: isNotDisplayChatButton,
                          onToggle: (value) async {
                            await prefs.setBool('settings_isNotDisplayChatButton', value);
                            bool subBool = prefs.getBool('settings_isNotDisplayChatButton') ?? value;
                            setState(() {
                              isNotDisplayChatButton = subBool;
                            });
                          },
                        ),
                        // - - - - - - - - - - - - - - - - - - - - - -
                      ],
                    ),
                    // -----------------------------------------------------------------------------
                    // ------------------------------ チャット機能の設定 ------------------------------
                    SettingsSection(
                      title: Text('チャット機能'),
                      tiles: [
                        // - - - - - - - - あいさつ応答機能 - - - - - - - -
                        SettingsTile.switchTile(
                          leading: Icon(Icons.emoji_people_outlined),
                          title: const Text('あいさつ応答機能を消す'),
                          initialValue: isNotDisplayGreeting,
                          onToggle: (value) async {
                            await prefs.setBool('settings_isNotDisplayGreeting', value);
                            bool subBool = prefs.getBool('settings_isNotDisplayGreeting') ?? value;
                            setState(() {
                              isNotDisplayGreeting = subBool;
                            });
                          },
                        ),
                        // - - - - - - - - - - - - - - - - - - - - - - -
                        // - - - - - - - チャット終了誘導機能 - - - - - - -
                        SettingsTile.switchTile(
                          leading: Icon(Icons.door_back_door_outlined),
                          title: const Text('チャット終了誘導機能を消す'),
                          initialValue: isNotDisplayEndChat,
                          onToggle: (value) async {
                            await prefs.setBool('settings_isNotDisplayEndChat', value);
                            bool subBool = prefs.getBool('settings_isNotDisplayEndChat') ?? value;
                            setState(() {
                              isNotDisplayEndChat = subBool;
                            });
                          },
                        ),
                        // - - - - - - - - - - - - - - - - - - - - - - -
                        // - - - - - - - - ミニゲーム機能 - - - - - - - - -
                        SettingsTile.switchTile(
                          leading: Icon(Icons.sports_esports_outlined),
                          title: const Text('ミニゲーム機能を消す'),
                          description: Text('このスイッチをオフで使える状態・オンで使えない状態になります'),
                          initialValue: isNotDisplayMiniGame,
                          onToggle: (value) async {
                            await prefs.setBool('settings_isNotDisplayMiniGame', value);
                            bool subBool = prefs.getBool('settings_isNotDisplayMiniGame') ?? value;
                            setState(() {
                              isNotDisplayMiniGame = subBool;
                            });
                          },
                        ),
                        // - - - - - - - - - - - - - - - - - - - - - - -
                      ]
                    ),
                    // -----------------------------------------------------------------------------
                    // -------------------------------- 使用パッケージ -------------------------------
                    SettingsSection(
                      title: Text('使用パッケージ'),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          leading: const Icon(Icons.book_outlined),
                          title: const Text('使用パッケージ'),
                          onPressed: (BuildContext context)  {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => UsePackagesPage(),
                              fullscreenDialog: true
                            ));
                          },
                          description: Text('使用しているパッケージの一覧とそのライセンスを表示します')
                        )
                      ]
                    ),
                    // -----------------------------------------------------------------------------
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

