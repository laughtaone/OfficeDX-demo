import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';



Future<void> functionPickFile({
    required Function(String argFileNameCallback) argFileNameCallback,
    required Function(FilePickerResult? argFilePickerResultCallback) argFilePickerResultCallback
}) async {
  FilePickerResult? keepSelectedFile;
  try {
    keepSelectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      withData: true, // バイトデータも取得
    );

    // ファイルが選択されたかチェック
    if (keepSelectedFile != null && keepSelectedFile.files.isNotEmpty) {
      final selectedFile = keepSelectedFile.files.first;

      // ファイル名をコールバック関数に渡す
      argFilePickerResultCallback(keepSelectedFile);
      argFileNameCallback(selectedFile.name);
    } else {
      debugPrint("ファイルが選択されませんでした");
    }
  } catch (e) {
    debugPrint("ファイル選択中にエラー: $e");
  }
}