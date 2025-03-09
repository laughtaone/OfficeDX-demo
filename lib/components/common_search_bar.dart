import 'package:flutter/material.dart';
import 'package:office_dx/pages/search_page/search_page.dart';



class CommonSearchBar extends StatefulWidget {
  const CommonSearchBar({
    super.key,
    this.argFocusSearchBox
  });

  final void Function(bool)? argFocusSearchBox;

  @override
  CommonSearchBarNotitleState createState() => CommonSearchBarNotitleState();
}


class CommonSearchBarNotitleState extends State<CommonSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String inputtedSearchWord = '';


  @override
  void initState() {
    super.initState();

    // フォーカスの状態を監視
    _focusNode.addListener(() {
      setState(() {});
      if (widget.argFocusSearchBox != null) {
        widget.argFocusSearchBox!(_focusNode.hasFocus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Container(
        width: 340,
        height: 65,
        decoration: BoxDecoration(
          color: (_focusNode.hasFocus) ? Color(0xffffffff) : null,    // 0xffe6e6e6
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 315,
                child: TextField(
                  onChanged: (String recvText) {
                    setState(() {
                      inputtedSearchWord = recvText;
                    });
                  },
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    prefixIcon: (_focusNode.hasFocus) ? null : Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3.0,
                      ),
                    ),
                    filled: false,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    hintText: '質問・項目を探す',
                    prefixText: (!_focusNode.hasFocus) ? inputtedSearchWord : '',
                    prefixStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis
                    ),
                    suffixIcon: (_focusNode.hasFocus)
                      ? IconButton(
                        icon: Icon(Icons.search_rounded, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: (inputtedSearchWord.isEmpty) ? Theme.of(context).primaryColor.withValues(alpha: 0.3) : Theme.of(context).primaryColor,
                          hoverColor: (inputtedSearchWord.isEmpty) ? Theme.of(context).primaryColor.withValues(alpha: 0) : Theme.of(context).primaryColor,
                      ),
                      disabledColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      onPressed: (inputtedSearchWord.isEmpty)
                        ? () {}
                        : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(
                                requestSearchWord: inputtedSearchWord,
                              ),
                              fullscreenDialog: true
                            ),
                          );
                        },
                      )
                      : Container(),
                  ),
                  onSubmitted: (String value) {
                    if (inputtedSearchWord.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(
                            requestSearchWord: inputtedSearchWord,
                          ),
                          fullscreenDialog: true
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
