import 'package:flutter/material.dart';
import 'package:office_dx/demo_components/demo_caution.dart';


AlertDialog demoUploadingDialog({int type = 1}) {
  return AlertDialog(
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
    content: SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
          SizedBox(height: 30),
          // ---------------- デモ用警告 ----------------
          DemoCaution(
            customIconSize: 18,
            customTextSize: 13,
            customLRPadding: 10
          ),
          SizedBox(height: 10),
          // -------------------------------------------
          Text(
            (type==1) ? 'アップロード中' : (type==2) ? '更新情報を\nアップロード中' :'削除処理中',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
