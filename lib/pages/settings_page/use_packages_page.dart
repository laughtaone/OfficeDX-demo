import 'package:flutter/material.dart';
import 'package:office_dx/components/common_sidebar_pages_appbar.dart';
import 'package:office_dx/components/dialog_ok_only.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:office_dx/pages/settings_page/use_packages_data.dart';
import 'package:url_launcher/url_launcher.dart';



class UsePackagesPage extends StatefulWidget {
  const UsePackagesPage({super.key});

  @override
  UsePackagesPageState createState() => UsePackagesPageState();
}

class UsePackagesPageState extends State<UsePackagesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonSidebarPagesAppbar(
        title: '使用パッケージ',
        iconData: Icons.book_outlined
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          // --------------------- 使用パッケージ・バージョン ---------------------
          SettingsSection(
            title: const Text(
              '使用パッケージ・バージョン',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
            ),
            tiles: [for (var item in usePackagesData)
              SettingsTile.navigation(
                title: Text(
                  item['name'] ?? '',
                  style: const TextStyle(fontSize: 18)
                ),
                value: Text(
                  item['version'] ?? '',
                  style: const TextStyle(fontSize: 18)
                ),
                onPressed: (BuildContext context) async {
                  final Uri siteUrl = Uri.parse(item['url'] ?? '');
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
            ],
          ),
          // ------------------------------------------------------------------
          // ---------------------------- ライセンス ---------------------------
          SettingsSection(
            title: const Text(
              'ライセンス (pub.devより引用 | 上記バージョン時のライセンス文)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
            ),
            tiles: [for (var item in usePackagesData)
              SettingsTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('[${item['name'] ?? ''}]', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(item['licence'] ?? '', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          )
          // ------------------------------------------------------------------
        ],
      ),
    );
  }
}
