import 'package:flutter/material.dart';


class TextfieldBorder extends StatefulWidget {
  final double height;
  final Function(String) onChanged;
  final String hintText;
  final String nowText;

  // コンストラクタで引数を受け取る
  const TextfieldBorder({super.key,
    required this.height,
    required this.onChanged,
    this.hintText = '未入力',
    this.nowText = ''
  });

  @override
  TextfieldBorderState createState() => TextfieldBorderState();
}

class TextfieldBorderState extends State<TextfieldBorder> {
  late TextEditingController textEditController;

  @override
  void initState() {
    super.initState();
    setState(() {
      textEditController = TextEditingController(text: widget.nowText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF0267B7),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: widget.height,
      child: TextField(
        scrollPhysics: BouncingScrollPhysics(),
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: textEditController,
        onChanged: (String recvString) {
          widget.onChanged(recvString);
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Color(0xFFE5534F)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        ),
      ),
    );
  }
}
