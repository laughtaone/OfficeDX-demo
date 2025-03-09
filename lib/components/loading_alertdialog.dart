import 'package:flutter/material.dart';



SizedBox loadingAlertDialog({
  double customHeight = 160,
  String customMessage = '読み込み中...'
}) {
  return SizedBox(
    height: customHeight,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
        const SizedBox(height: 30),
        Text(customMessage, style: TextStyle(fontSize: 18)),
      ],
    ),
  );
}