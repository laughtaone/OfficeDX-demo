import 'package:flutter/material.dart';
import 'package:office_dx/components/logo.dart';
import 'package:office_dx/components/q_button.dart';
import 'package:office_dx/components/common_search_bar.dart';
import 'package:office_dx/components/app_text.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key,
    this.isNotDisplaySchoolName = false
  });

  final bool isNotDisplaySchoolName;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isFocusSearchbox = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f6f7),
      body: SingleChildScrollView(
        physics: (isFocusSearchbox) ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        child: Container(
          color: Color(0xfff3f6f7),
          height: 700,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // ----------------------------- 書類表示 -----------------------------
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                  child: SchoolLogo(isNotDisplaySchoolName: widget.isNotDisplaySchoolName),
                ),
                // -------------------------------------------------------------------
                // ----------------------------- タイトル -----------------------------
                AppText(customText: (widget.isNotDisplaySchoolName) ? '******電子窓口' : '産技高専電子窓口'),
                // -------------------------------------------------------------------

                const SizedBox(height: 10),

                // ----------------------------- 検索バー -----------------------------
                CommonSearchBar(
                  argFocusSearchBox:(bool recvIsFocus) {
                    setState(() {
                      isFocusSearchbox = recvIsFocus;
                    });
                  },
                ),
                // -------------------------------------------------------------------

                const SizedBox(height: 30),

                // --------------------------- 問い合わせボタン -------------------------
                QButton(),
                // -------------------------------------------------------------------

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
