import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({super.key,
    this.customColor,
    this.customFontWeight = FontWeight.w800,
    this.customText = '産業技術高専電子窓口',
    this.isNotDisplaySchoolName = false
  });

  final Color? customColor;
  final FontWeight customFontWeight;
  final String customText;
  final bool isNotDisplaySchoolName;


  @override
  Widget build(BuildContext context) {
    return Text(
      (isNotDisplaySchoolName) ? '*'*customText.length : customText,
      style: TextStyle(
        color: (customColor != null) ? customColor : Theme.of(context).primaryColor,
        fontWeight: customFontWeight,
        fontSize: 20
      ),
    );
  }
}
