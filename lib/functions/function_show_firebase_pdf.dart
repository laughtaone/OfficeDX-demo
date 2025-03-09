import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';


Future<void> functionShowFirebasePdf({
  required bool isFirebaseInitialized,
  required BuildContext context,
  required String fileName,
  required String fileUrl,
  required Function(bool) argIsLoadingPdfCallback
}) async {
  try {
    argIsLoadingPdfCallback(true);

    if (!kIsWeb) {
      // - - - - - - - - - - - - - - ネイティブ環境の場合 - - - - - - - - - - - - - -
      // Firebaseの初期化が完了しているか確認
      if (!isFirebaseInitialized) {
        throw 'Firebaseが初期化されていません';
      }
      // デバイスの一時ディレクトリのパスを取得
      final Directory tempDir = await getTemporaryDirectory();
      // 取得した一時ディレクトリ下に、ファイルオブジェクトを作成
      final File tempFile = File('${tempDir.path}/uploaded_pdf/$fileName');
      // PDFファイルを保存するための完全なパスを生成
      final String pdfPath = tempFile.path;

      final Reference pdfFirebaseReference = FirebaseStorage.instance.refFromURL(fileUrl);

      // Firebase Storageから持ってきたファイルをローカルのファイルシステムに書き込む
      try {
        // ディレクトリの存在を確認した上でローカルに書き込み
        if (!(await tempFile.parent.exists())) {
          await tempFile.parent.create(recursive: true);
        }
        await pdfFirebaseReference.writeToFile(tempFile);
      } on FirebaseException catch (e) {
        if (e.code == 'object-not-found') {
          throw '指定されたパスにオブジェクトが存在しません: $fileName';
        } else {
          throw 'Firebase Storageから持ってきたファイルをローカルのファイルシステムに書き込む途中でエラー: ${e.message}';
        }
      }
      argIsLoadingPdfCallback(false);

      final result = await OpenFilex.open(pdfPath);
      if (result.type != ResultType.done) {
        throw 'Could not open $pdfPath';
      }
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    } else {
      // - - - - - - - - - - - - - - - Web環境の場合 - - - - - - - - - - - - - - - -
      if (await canLaunchUrl(Uri.parse(fileUrl))) {
        await launchUrl(Uri.parse(fileUrl));
      } else {
        // URLを開けない場合の処理
        debugPrint('FirebaseからのPDF表示中にエラー(Web版) $fileUrl');
      }
      argIsLoadingPdfCallback(false);
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    }
  } catch (e) {
    debugPrint('FirebaseからのPDF表示中にエラー: $e');
    argIsLoadingPdfCallback(false);
  }
}
