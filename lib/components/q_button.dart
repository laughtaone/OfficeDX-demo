import 'package:flutter/material.dart';
import 'package:office_dx/pages/3_bottom_tabs/form_page.dart';

class QButton extends StatelessWidget {
  const QButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 58,
        width: 280,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormPage())),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
          child: const Text(
            '質問・お問い合わせ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ));
  }
}
