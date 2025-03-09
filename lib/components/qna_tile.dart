import 'package:flutter/material.dart';

class QNATile extends StatelessWidget {
  const QNATile({super.key,
    required this.createdAt,
    required this.question,
    required this.onTap,
    required this.updatedAt,
    required this.categoryName,
    this.customMaxWidth = 150,
    this.needUnderline = true
  });

  final String createdAt;
  final String question;
  final VoidCallback onTap;
  final String updatedAt;
  final String categoryName;
  final double customMaxWidth;
  final bool needUnderline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: InkWell(
                onTap: onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff50aad8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: 150,
                      ),
                      padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                      child: Text(
                        categoryName,
                        style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                        Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.schedule_outlined, size: 14, color: subColor)),
                        SizedBox(width: 3),
                        Text(
                          createdAt,
                          style: TextStyle(color: subColor, fontSize: 12, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                      (updatedAt == '1900/1/1 00:00')    // 更新がある場合は更新日時も表示
                        ? SizedBox.shrink()
                        : Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                          SizedBox(width: 15),
                          Padding(padding: const EdgeInsets.only(top: 2), child: Icon(Icons.update_outlined, size: 14, color: subColor)),
                          SizedBox(width: 3),
                          Text(
                            updatedAt,
                            style: TextStyle(color: subColor, fontSize: 12, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(children: [
                    Flexible(
                      child: Text(
                        question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Theme.of(context).primaryColor)
                      )
                    )
                  ]),
                ],
              )
            )
          ),
          (needUnderline) ? Divider(thickness: 1.5, color: Theme.of(context).colorScheme.secondary) : Container()
        ],
      ),
    );
  }
}


final Color subColor = Color(0xFF9FC7E7);