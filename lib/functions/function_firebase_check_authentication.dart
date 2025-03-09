import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



void checkUserAuthentication({
  required User? user,
  required BuildContext context
}) {
  if (user == null) {
    // ユーザーが認証されていない場合、ログインを促す
    Navigator.pushNamed(context, '/login');
  } else {
    // ユーザーが認証されている場合、ストレージにアクセス
  }
}