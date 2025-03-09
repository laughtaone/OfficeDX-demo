import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future functionFirebaseUploadDocNew({
  required FirebaseFirestore firestoreInstance,
  required FirebaseStorage storageInstance,
  required FilePickerResult? uploadFile,      // アップロードするファイル本体
  required String docName,                    // 書類名(ファイル名ではない)
  required Function(bool) argUpdateIsUploading,
  required Function(FilePickerResult?) argResultSelectedFile,
}) async {
  late String uploadUrl;

  argUpdateIsUploading(true);

  // 選択したファイルが入っている変数は、resultSelectedFile
  if (uploadFile != null) {
    // ↓ Firebase Storageのインスタンスを取得し、ストレージのルートリファレンスをstorageRefに代入
    try {
      final uploadedFile = uploadFile.files.first.bytes;
      if (uploadedFile != null) {
        final uploadTask = await storageInstance
            .ref('uploaded_pdf/${uploadFile.files[0].name}')
            .putData(uploadFile.files[0].bytes!);
        uploadUrl = await uploadTask.ref.getDownloadURL(); // URL取得
      }
      // ↓ Firestoreに情報を書き込み
      await firestoreInstance.collection('document_records').add({
        'docName': docName,
        'fileUrl': uploadUrl,
        'fileName': uploadFile.files.first.name,
        'createdAt': Timestamp.now(), // 現在の日時
      });

      debugPrint('✅Firebaseにアップロード完了');
    } catch (e) {
      debugPrint('Firebaseアップロード中にエラー：$e');
    } finally {
      argUpdateIsUploading(false);
      argResultSelectedFile(null);
    }
  }
}