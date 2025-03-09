// デモ用の関数 (元コードの不要な部分は消さずにコメントアウトして実装)

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:office_dx/demo_functions/demo_function_wait.dart';
/*
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
*/


Future demoFunctionFirebaseUploadDocUpdate({
  /*
  required FirebaseFirestore firestoreInstance,
  required FirebaseStorage storageInstance,
  required String targetDocId,
  required int updateType,                    // 書類名とファイル両方変更なら0・書類名のみ変更なら1・ファイルのみ変更なら2
  required String? newDocName,                // 【updateTypeが0,1の時のみ必要】書類名(ファイル名ではない)
  required FilePickerResult? uploadFile,      // 【updateTypeが0,2の時のみ必要】アップロードするファイル本体
  required String? oldFileUrl,                // 【updateTypeが0,2の時のみ必要】古いファイルのFirebase StorageのURL
  */
  required Function(bool) argIsUploadingCallback,     // アップロード中かどうかを反映させるコールバック
  required Function(FilePickerResult?) argResultSelectedFile,
}) async {
  argIsUploadingCallback(true);


  /*
  if (updateType == 0) {
    String newFileName = '';
    late String newFilelUrl;

    // ---------------------- Firebase Storageへのアップロード処理 ---------------------
    try {
      if (uploadFile != null) {
        // ↓ Firebase Storageのインスタンスを取得し、ストレージのルートリファレンスをstorageRefに代入
        try {
          final uploadedFile = uploadFile.files[0].bytes;
          newFileName = uploadFile.files.first.name;
          if (uploadedFile != null) {
            final uploadTask = await storageInstance
              .ref('uploaded_pdf/$newFileName')
              .putData(uploadFile.files[0].bytes!);
              newFilelUrl = await uploadTask.ref.getDownloadURL(); // URL取得
          }

          debugPrint('✅【更新】Firebase Storageに新PDFファイルのアップロード完了');

          argIsUploadingCallback(false);
          argResultSelectedFile(null);
        } catch (e) {
          debugPrint('❌【更新】Firebase Storageに新PDFファイルのアップロード中にエラー：$e');
          argIsUploadingCallback(false);
          argResultSelectedFile(null);
        }
      }
    } catch (e) {
      debugPrint('❌【更新】Firebase Storageに新PDFファイルのアップロード中にエラー：$e');
    }
    // -----------------------------------------------------------------------------

    // ------------------ Firebase Storageにある古いファイルの削除処理 ------------------
    try {
      if (oldFileUrl != null) {
        final storageReference = FirebaseStorage.instance.refFromURL(oldFileUrl);
        await storageReference.delete();
      }
      debugPrint('✅【更新】Firebase Storageにある古いファイルの削除処理完了');
    } catch (e) {
      debugPrint('❌【更新】Firebase Storageにある古いファイルの削除処理にエラー：$e');
    }
    // -----------------------------------------------------------------------------

    // ----------------------- Cloud FireStoreへのアップロード処理 --------------------
    assert(newDocName != null);
    debugPrint('🫰newDocNameは、$newDocName');
    debugPrint('🫰newFileNameは、$newFileName');
    try {
      await firestoreInstance.collection('document_records').doc(targetDocId).update({
        'docName': newDocName,
        'fileName': newFileName,
        'fileUrl': newFilelUrl,
        'updatedAt': Timestamp.now(), // 現在の日時
      });
      debugPrint('✅【更新】Cloud Firestoreにファイル名のアップロード完了');
    } catch (e) {
      debugPrint('❌【更新】Cloud Firestoreにファイル名をアップロード中にエラー：$e');
    }
    // ----------------------------------------------------------------------------
  } else if (updateType == 1) {
    // 書類名のみ更新
    assert(newDocName != null);
    // ---------------------- Cloud Firestoreへのアップロード処理 ----------------------
    try {
      await firestoreInstance.collection('document_records').doc(targetDocId).update({
        'docName': newDocName,
        'updatedAt': Timestamp.now(), // 現在の日時
      });
      debugPrint('✅【更新】Cloud Firestoreに書類名のアップロード完了');
    } catch (e) {
      debugPrint('❌【更新】Cloud Firestoreに書類名をアップロード中にエラー：$e');
    }
    // -----------------------------------------------------------------------------
  } else if (updateType == 2) {
    // ファイルのみ更新
    String? newFileName;
    String? newFilelUrl;

    // ---------------------- Firebase Storageへのアップロード処理 ---------------------
    try {
      if (uploadFile != null && uploadFile.files.isNotEmpty) {
        // ↓ Firebase Storageのインスタンスを取得し、ストレージのルートリファレンスをstorageRefに代入
        try {
          final uploadedFile = uploadFile.files[0].bytes;
          newFileName = uploadFile.files.first.name;
          if (uploadedFile != null) {
            final uploadTask = await storageInstance
              .ref('uploaded_pdf/$newFileName')
              .putData(uploadFile.files[0].bytes!);
              newFilelUrl = await uploadTask.ref.getDownloadURL(); // URL取得
          }

          debugPrint('✅【更新】Firebase Storageに新PDFファイルのアップロード完了');

          argIsUploadingCallback(false);
          argResultSelectedFile(null);
        } catch (e) {
          debugPrint('❌【更新】Firebase Storageに新PDFファイルのアップロード中にエラー：$e');
          argIsUploadingCallback(false);
          argResultSelectedFile(null);
        }
      }
    } catch (e) {
      debugPrint('❌【更新】Firebase Storageに新PDFファイルのアップロード中にエラー：$e');
    }
    // -----------------------------------------------------------------------------

    // ------------------ Firebase Storageにある古いファイルの削除処理 ------------------
    try {
      if (oldFileUrl != null) {
        final storageReference = FirebaseStorage.instance.refFromURL(oldFileUrl);
        await storageReference.delete();
      }
      debugPrint('✅【更新】Firebase Storageにある古いファイルの削除処理完了');
    } catch (e) {
      debugPrint('❌【更新】Firebase Storageにある古いファイルの削除処理にエラー：$e');
    }
    // -----------------------------------------------------------------------------

    // ----------------------- Cloud FireStoreへのアップロード処理 --------------------
    try {
      if (newFileName != null && newFilelUrl != null) {
        await firestoreInstance.collection('document_records').doc(targetDocId).update({
          'fileName': newFileName,
          'fileUrl': newFilelUrl,
          'updatedAt': Timestamp.now(), // 現在の日時
        });
        debugPrint('✅【更新】Cloud Firestoreにファイル名のアップロード完了');
      } else {
        debugPrint('❌【更新】Cloud Firestoreにファイル名のアップロードに失敗しました');
      }
    } catch (e) {
      debugPrint('❌【更新】Cloud Firestoreにファイル名をアップロード中にエラー：$e');
    }
    // ----------------------------------------------------------------------------
  }
  */

  await demoFunctionWait(mSec: 3000);  // (デモ用) 1秒待機

  argResultSelectedFile(null);
  argIsUploadingCallback(false);
  debugPrint('✅【更新】Firebase storageInstance/Cloud firestoreInstance にアップロードが全体完了');
}