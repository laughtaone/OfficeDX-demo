import 'package:flutter/material.dart';
import 'package:office_dx/pages/admin_page/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:office_dx/components/dialog_ok_only.dart';
import 'package:office_dx/components/sidebar_square_item.dart';
import 'package:office_dx/components/app_text.dart';
import 'package:office_dx/pages/settings_page/settings_page.dart';
import 'package:office_dx/pages/about_system_page/about_system_page.dart';




class SideBar extends StatefulWidget {
  const SideBar({super.key,
    required this.argOpenedSettingsPage,
    this.isNotDisplaySchoolName = false
  });

  final Function(bool) argOpenedSettingsPage;
  final bool isNotDisplaySchoolName;

  @override
  SideBarState createState() => SideBarState();
}


class SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color(0xFF347AB5),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // ---------------------- タイトル -------------------------
              SizedBox(height: 50),
              AppText(
                customText: (widget.isNotDisplaySchoolName) ? '******電子窓口\n(非公式|デモ版)' : '産技高専電子窓口\n（非公式|デモ版）',
                customColor: Colors.white,
                customFontWeight: FontWeight.w500,
                customFontSize: 18
              ),
              SizedBox(height: 15),
              Text(
                'サイドバー',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
              ),
              // --------------------------------------------------------

              SizedBox(height: 15),

              Flexible(
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10, // アイテム間の横のスペース
                    mainAxisSpacing: 10, // アイテム間の縦のスペース
                  ),
                  children: [
                    SidebarSquareItem(
                      icon: Icons.person_outlined,
                      text: '管理者\nログインページ',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                    ),

                    SidebarSquareItem(
                      icon: Icons.language_outlined,
                      text: '本校HP',
                      onTap: () async {
                        final Uri siteUrl = Uri.parse('https://www.metro-cit.ac.jp/');
                        try{
                          launchUrl(siteUrl);
                        } catch (e) {
                          // URLを開けない場合の処理
                          if (!mounted) return;
                          debugPrint('サイト表示試行中にエラー(本校HP) $siteUrl');

                          // contextが無効な場合にダイアログを表示しないようにする
                          if (!mounted || !context.mounted) return;

                          dialogOkOnly(
                            dialogText: 'サイト表示中にエラーが発生しました',
                            context: context,
                            onPressed: () {
                              if (mounted && context.mounted) {
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                              }
                            }
                          );
                        }
                      },
                    ),

                    SidebarSquareItem(
                      icon: Icons.info_outlined,
                      text: '本システム\nについて',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutSystemPage(),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                    ),

                    SidebarSquareItem(
                      icon: Icons.settings_outlined,
                      text: '設定',
                      onTap: () async {
                        Navigator.pop(context);
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                            fullscreenDialog: true,
                          ),
                        );

                        if (result != null) {
                          widget.argOpenedSettingsPage(true);
                        }
                      }
                    )
                  ]
                ),
              ),
            ],
          ),
        )
      );
  }
}

