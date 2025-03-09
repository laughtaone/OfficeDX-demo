import 'package:flutter/material.dart';


class CommonBottombar extends StatefulWidget {
  const CommonBottombar({
    super.key,
    required this.onTap,
  });

  final Function(int) onTap;

  @override
  State<CommonBottombar> createState() => CommonBottombarState();
}

class CommonBottombarState extends State<CommonBottombar> {
  int index = 1;

  BottomNavigationBarItem _customBottomItem({
    required IconData icon,
    required String label,
    required bool isSelected
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        width: 115,
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: (isSelected) ? Colors.white.withValues(alpha: 0.25) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            Text(label, style: TextStyle(fontSize: 20, color: Colors.white))
          ],
        )
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.8; // 画面幅の80%
    return SizedBox(
      // height: 100,
      width: maxWidth,
      child: BottomNavigationBar(
        // アイコンサイズ
        iconSize: 35,
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 24),
        // ラベルの色設定をここで行う（統一する）
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        //ラベルのTextstyle設定（fontSizeを統一させる）
        selectedLabelStyle: const TextStyle(fontSize: 0),
        unselectedLabelStyle: const TextStyle(fontSize: 15),
        backgroundColor: Theme.of(context).primaryColor,
        onTap: (value) {
          setState(() {
            widget.onTap(value);
            index = value;
          });
        },
        currentIndex: index,
        items: [
          _customBottomItem(
            icon: Icons.description,
            label: '書類',
            isSelected: index == 0
          ),
          _customBottomItem(
            icon: Icons.home,
            label: 'Home',
            isSelected: index == 1
          ),
          _customBottomItem(
            icon: Icons.contact_support_outlined,
            label: 'Q&A',
            isSelected: index == 2
          ),
        ]
      ),
    );
  }
}
