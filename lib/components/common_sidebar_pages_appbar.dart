import 'package:flutter/material.dart';



class CommonSidebarPagesAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonSidebarPagesAppbar({super.key,
    required this.title,
    required this.iconData
  });

  final String title;
  final IconData iconData;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(iconData, color: Colors.white),
          ),
          SizedBox(width: 5),
          Text(title, style: TextStyle(color: Colors.white)),
        ],
      ),
      actions: [IconButton(
        onPressed: () => Navigator.pop(context, true),
        icon: const Icon(Icons.close, color: Colors.white)
      )],
    );
  }
}