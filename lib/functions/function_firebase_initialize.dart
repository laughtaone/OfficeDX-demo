import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> functionFirebaseInitialize() async {
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebaseの初期化');
  } catch (e) {
    debugPrint('Firebase initializationでエラー：$e');
  }
}