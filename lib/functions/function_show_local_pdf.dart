import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_filex/open_filex.dart';
import 'package:flutter/foundation.dart';



Future<void> showLocalPdf({
  required BuildContext context,
  required String pdfFileName
}) async {
  try {
    // アセットからPDFファイルを読み込み
    final ByteData data = await rootBundle.load('pdf/$pdfFileName');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/$pdfFileName');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    // PDFを開く
    final String pdfPath = tempFile.path;
    final result = await OpenFilex.open(pdfPath);
    if (result.type != ResultType.done) {
      throw 'Could not open $pdfPath';
    }
  } catch (e) {
    debugPrint('ローカルからのPDF表示中にエラー：$e');
  }
}