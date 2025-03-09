// デモ用の関数
// 非同期処理を行い、指定秒数後にコールバック関数を呼び出す
// Firebaseに擬似的に上げているようにするための関数(デモページではFirebaseの内容はいじれないようにするため)

Future<void> demoFunctionWait({
  required int mSec,
  // required Function(bool) argCallback,
}) async {

  await Future.delayed(Duration(milliseconds: mSec), () {
    // argCallback(true);
  });
}