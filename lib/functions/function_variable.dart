import 'package:cloud_firestore/cloud_firestore.dart';



Timestamp notUpdatedAt = Timestamp.fromMillisecondsSinceEpoch(DateTime(1900, 1, 1).millisecondsSinceEpoch);

// ------------------------------------- Timestamp型を受け取り、次の形でテキストで返す --------------------------------------
// 「yyyy/mm/dd」
String formatDateYMD(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  return formattedDate;
}

// 「yyyy/mm/dd hh:mm」
String formatDateAndTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  return formattedDate;
}
// --------------------------------------------------------------------------------------------------------------------
