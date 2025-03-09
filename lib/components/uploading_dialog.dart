import 'package:flutter/material.dart';


AlertDialog uploadingDialog({int type = 1}) {
  return AlertDialog(
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
    content: SizedBox(
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          SizedBox(height: 65, width: 65, child: CircularProgressIndicator()),
          SizedBox(height: 30),
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
