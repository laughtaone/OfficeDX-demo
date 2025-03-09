import 'package:flutter/material.dart';
import 'package:office_dx/components/close_circle_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';


class QaFilterButton extends StatefulWidget {
  const QaFilterButton({
    super.key,
    required this.categoryMap,
    required this.searchCondList,
    required this.argSearchCondList,
    required this.argComplete
  });

  final Map<String, Map<String, dynamic>> categoryMap;
  final List<String> searchCondList;
  final Function(List<String>) argSearchCondList;
  final Function(bool) argComplete;

  @override
  QaFilterButtonState createState() => QaFilterButtonState();
}

class QaFilterButtonState extends State<QaFilterButton> {
  List<String> keepSearchCondList = []; // 検索対象のカテゴリのみを格納するリスト
  bool isCompletePressed = false;       // 完了ボタンを押したかどうかの真偽値
  bool isSelectedAll = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.argComplete(false);
  }

  void _initializeKeepSearchCondList() {
    setState(() {
      keepSearchCondList = List.of(widget.searchCondList);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.only(top: 0),
      child: TextButton(
        onPressed: () {
          _initializeKeepSearchCondList();
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Color(0xfff9f9f9),
                    content: SingleChildScrollView(
                      child: SizedBox(
                        width: 450,
                        child: Column(
                          children: [
                            // -------------------- 上部分 ---------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: AutoSizeText('カテゴリで絞り込む', style: TextStyle(fontSize: 22), maxLines: 1)),
                                CloseCircleButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                            // ------------------------------------------------
      
                            SizedBox(height: 10),
      
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  // ---------------- カテゴリ選択説明 -----------------
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        '表示するカテゴリを選択：',
                                        style: TextStyle(fontSize: 15, color: Colors.black),
                                        maxLines: 1
                                      )
                                    ),
                                    // ------------------------------------------------
                              
                                    SizedBox(height: 12),
                              
                                    // ---------------- チェックボックス -----------------
                                    Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      thickness: 2,
                                      child: Container(
                                        color: Colors.white,
                                        height: 350,
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          itemCount: widget.categoryMap.length,
                                          itemBuilder: (context, index) {
                                            String categoryKey = widget.categoryMap.keys.elementAt(index);
                                            String categoryName = widget.categoryMap[categoryKey]!['categoryName'];
      
                                            return TextButton(
                                              onPressed: () {
                                                setDialogState(() {
                                                  setState(() {
                                                    if (keepSearchCondList.contains(categoryKey)) {
                                                    keepSearchCondList.remove(categoryKey);
                                                  } else {
                                                    keepSearchCondList.add(categoryKey);
                                                  }
                                                  });
                                                });
      
                                                debugPrint('🪼 keepSearchCondListは、\n$keepSearchCondList');
                                                debugPrint('🪼 widget.searchCondListは、\n${widget.searchCondList}');
                                              },
                                              style: TextButton.styleFrom(
                                                fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 55),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(0)
                                                )
                                              ),
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: keepSearchCondList.contains(categoryKey),
                                                    onChanged: (bool? _) {
                                                      setDialogState(() {
                                                        if (keepSearchCondList.contains(categoryKey)) {
                                                          setState(() {
                                                            keepSearchCondList.remove(categoryKey);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            keepSearchCondList.add(categoryKey);
                                                          });
                                                        }
      
                                                        debugPrint('🪼 keepSearchCondListは、\n$keepSearchCondList');
                                                        debugPrint('🪼 widget.searchCondListは、\n${widget.searchCondList}');
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(width: 5),
                                                  AutoSizeText(
                                                    categoryName,
                                                    style: TextStyle(color: Colors.black, fontSize: 17),
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // ------------------------------------------------
      
                                    SizedBox(height: 15),
      
                                    // ------------------- 下部ボタン -------------------
                                    Stack(
                                      children: [
                                        // リセットボタン（左端）
                                        Positioned(
                                          left: 0, top: 0, bottom: 0,
                                          child: Center(child: IconButton(
                                            style: IconButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                            ),
                                            onPressed: () {
                                              setDialogState(() {
                                                keepSearchCondList.clear();
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete_outlined,
                                              color: Colors.black54,
                                              size: 20
                                            ),
                                          )),
                                        ),
      
                                        // 完了ボタン（中央）
                                        Center(
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                              disabledBackgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                                              backgroundColor: Theme.of(context).primaryColor,
                                              fixedSize: Size(140, 60),
                                            ),
                                            onPressed: (const DeepCollectionEquality().equals(keepSearchCondList, widget.searchCondList))
                                              ? null
                                              : () {
                                                  setState(() {
                                                    isCompletePressed = true;
                                                    if (keepSearchCondList.length == widget.categoryMap.length) {
                                                      isSelectedAll = true;
                                                    } else {
                                                      isSelectedAll = false;
                                                    }
                                                  });
                                                  widget.argSearchCondList(keepSearchCondList);
                                                  widget.argComplete(true);
                                                  Navigator.of(context).pop();
                                                },
                                            child: const Text('完了', style: TextStyle(color: Colors.white, fontSize: 18)),
                                          ),
                                        ),
                                      ],
                                    )
                                    // ------------------------------------------------
                                  ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        style: (widget.searchCondList.isEmpty)
          ? TextButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.symmetric(horizontal: 15),
          )
          : TextButton.styleFrom(
            backgroundColor: (isSelectedAll) ? backMaxColor : backColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17)
            ),
          ),
        child: (widget.searchCondList.isEmpty)
          ? Icon(Icons.filter_alt_outlined, color: Theme.of(context).primaryColor, size: 22)
          : Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: (isSelectedAll) ? maxMainColor : mainColor),
                SizedBox(width: 3),
                AutoSizeText(
                  (isSelectedAll)
                    ? 'ALL'
                    : widget.searchCondList.length.toString(),
                  style: TextStyle(
                    color: (isSelectedAll) ? maxMainColor : mainColor,
                  ),
                )
              ],
            )
      ),
    );
  }
}


final Color mainColor = Color(0xff5979ec);
final Color backColor = Color(0xffe2e9ff);
final Color maxMainColor = Color(0xff15bc33);
final Color backMaxColor = Color(0xffe3ffe2);