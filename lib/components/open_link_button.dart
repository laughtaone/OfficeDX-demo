import 'package:flutter/material.dart';
import 'package:office_dx/components/dialog_ok_only.dart';
import 'package:url_launcher/url_launcher.dart';



class OpenLinkButton extends StatefulWidget {
  const OpenLinkButton({
    super.key,
    required this.url,
    required this.buttonChild,
    this.customBackColor,
    this.customTopPadding
  });

  final String url;
  final Widget buttonChild;
  final Color? customBackColor;
  final double? customTopPadding;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<OpenLinkButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5, top: widget.customTopPadding ?? 0),
      child: TextButton(
        onPressed:  () async {
          final Uri siteUrl = Uri.parse(widget.url);
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
        style: TextButton.styleFrom(
          backgroundColor: widget.customBackColor,
        ),
        child: widget.buttonChild
      ),
    );
  }
}
