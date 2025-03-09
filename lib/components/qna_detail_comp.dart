import 'package:flutter/material.dart';

class QNADetailComp extends StatelessWidget {
  const QNADetailComp({super.key,
    required this.createdAt,
    required this.question,
    required this.answer,
    required this.categoryName,
    required this.updatedAt
  });

  final String createdAt;
  final String question;
  final String answer;
  final String categoryName;
  final String updatedAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 14,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 11,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                      Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.schedule_outlined, size: 14, color: subColor)),
                      SizedBox(width: 3),
                      Text(
                        createdAt,
                        style: TextStyle(color: subColor, fontSize: 12, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ),

                  // (updatedAt == null)    // 更新がある場合は更新日時も表示
                  (updatedAt == '1900/1/1 00:00')    // 更新がある場合は更新日時も表示
                  ? SizedBox.shrink()
                  : Flexible(
                    flex: 11,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                        SizedBox(width: 15),
                        Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.update_outlined, size: 14, color: subColor)),
                        // Text('更新日', style: TextStyle(color: introPdfColor, fontSize: 11, fontWeight: FontWeight.w500)),
                        SizedBox(width: 3),
                        Text(
                          updatedAt,
                          style: TextStyle(color: subColor, fontSize: 12, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                  ),
                  Flexible(flex: 1, child: SizedBox(width: 4))
                ],
              ),
            ),
            // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

            const SizedBox(height: 2),
            Text('カテゴリ：$categoryName', style: TextStyle(color: subColor, fontSize: 12)),
            const SizedBox(height: 15),
            Row(children: [
              Flexible(
                child: Text(
                  question,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Theme.of(context).primaryColor)
                )
              ),
            ]),
            const SizedBox(height: 15),
            Text(
              answer,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 15),
            Divider(thickness: 1.5, color: Theme.of(context).colorScheme.secondary)
          ],
        ));
  }
}



Container tateLine({required double height}) {
  return Container(
    margin: const EdgeInsets.only(left: 7, right: 7),
    height: height,
    width: 1,
    color: subColor
  );
}

final Color subColor = Color(0xFF9FC7E7);